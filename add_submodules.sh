#!/usr/bin/env bash
# add_submodules.sh
#
# Reads a CSV file, adds any missing git submodules, and rewrites the
# "## Submodules" section of README.md with a full table of contents.
#
# CSV format (one entry per line):
#   url,local_path[,description]
#
#   • Lines starting with # (after stripping whitespace) are treated as
#     section-header comments and become table section headings in the README.
#   • Blank lines are ignored.
#   • If a description column is omitted, the script will attempt to fetch it
#     from the GitHub API (requires curl; falls back to blank gracefully).
#   • Set GITHUB_TOKEN env var to avoid API rate limits (60 req/hr unauthenticated
#     vs 5000/hr authenticated).
#
# Usage:
#   ./add_submodules.sh [csv_file]         # defaults to submodules.csv
#   ./add_submodules.sh submodules.csv --dry-run
#
# Options:
#   --dry-run        Print what would be done without making any changes.
#   --update         After adding submodules, run `git submodule update --init --recursive`
#   --no-readme      Skip README.md update entirely.
#   --readme FILE    Write README section to FILE instead of README.md
#   --help           Show this message.

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
CSV_FILE="submodules.csv"
DRY_RUN=false
DO_UPDATE=false
UPDATE_README=true
README_FILE="README.md"

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=true;        shift ;;
    --update)     DO_UPDATE=true;      shift ;;
    --no-readme)  UPDATE_README=false; shift ;;
    --readme)     README_FILE="$2";    shift 2 ;;
    --help)
      sed -n '2,29p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    --*)
      echo "Unknown option: $1" >&2; exit 1 ;;
    *)
      CSV_FILE="$1"; shift ;;
  esac
done

# ── Sanity checks ─────────────────────────────────────────────────────────────
if [[ ! -f "$CSV_FILE" ]]; then
  echo "ERROR: CSV file not found: $CSV_FILE" >&2
  exit 1
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: Not inside a git repository." >&2
  exit 1
fi

HAVE_CURL=false
command -v curl &>/dev/null && HAVE_CURL=true

# ── Helper: strip leading+trailing whitespace ─────────────────────────────────
trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# ── Helper: fetch GitHub repo description via API ─────────────────────────────
# Accepts a URL like https://github.com/owner/repo[.git] and echoes the
# description string, or nothing on failure.
github_description() {
  local url="$1"

  [[ "$HAVE_CURL" == false ]] && echo "" && return 0

  # Only handle github.com URLs
  if ! printf '%s' "$url" | grep -q 'github\.com'; then
    echo "" && return 0
  fi

  # Extract owner/repo slug
  local slug
  slug=$(printf '%s' "$url" \
    | sed 's|\.git$||; s|/$||' \
    | sed 's|.*github\.com/||')

  local api_url="https://api.github.com/repos/${slug}"

  local response=""
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    response=$(curl -sf \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github+json" \
      "$api_url" 2>/dev/null || true)
  else
    response=$(curl -sf \
      -H "Accept: application/vnd.github+json" \
      "$api_url" 2>/dev/null || true)
  fi

  [[ -z "$response" ]] && echo "" && return 0

  # Extract description field (avoids jq dependency)
  local desc
  desc=$(printf '%s' "$response" \
    | grep -o '"description":[[:space:]]*"[^"]*"' \
    | head -1 \
    | sed 's/"description":[[:space:]]*"//; s/"$//' \
    | sed 's/\\"/"/g' \
    || true)

  # Return empty if null or missing
  if [[ "$desc" == "null" || -z "$desc" ]]; then
    echo "" && return 0
  fi

  printf '%s' "$desc"
}

# ── Counters ──────────────────────────────────────────────────────────────────
added=0
skipped=0
errors=0

echo "Reading: $CSV_FILE"
$DRY_RUN && echo "(dry-run mode — no changes will be made)"
echo ""

# ── Data for README ───────────────────────────────────────────────────────────
# README_SECTIONS: array of heading strings
# README_ROWS: "sec_idx|url|local_path|description" per data row
declare -a README_SECTIONS=()
declare -a README_ROWS=()
current_section_idx=-1

# ── Main loop ─────────────────────────────────────────────────────────────────
while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do

  line=$(trim "$raw_line")
  [[ -z "$line" ]] && continue

  # ── Comment → potential section heading ───────────────────────────────────
  if [[ "$line" == \#* ]]; then
    heading=$(trim "${line#\#}")
    # Only use as heading if it has real word characters (skip ─── separators)
    if printf '%s' "$heading" | grep -q '[A-Za-z0-9]'; then
      README_SECTIONS+=("$heading")
      (( current_section_idx++ )) || true
    fi
    continue
  fi

  # ── Data row: split on first two commas only ───────────────────────────────
  url=$(trim "$(printf '%s' "$line" | cut -d',' -f1)")
  local_path=$(trim "$(printf '%s' "$line" | cut -d',' -f2)")
  description=$(trim "$(printf '%s' "$line" | cut -d',' -f3-)")

  if [[ -z "$url" || -z "$local_path" ]]; then
    echo "  SKIP  (malformed line): $raw_line"
    (( skipped++ )) || true
    continue
  fi

  # Fetch description from GitHub API if not in CSV
  if [[ -z "$description" ]]; then
    printf '  DESC  %-60s' "${url##*/}"
    description=$(github_description "$url")
    if [[ -n "$description" ]]; then
      echo "✓"
    else
      echo "-"
    fi
  fi

  # Always store the row for README even if we skip the submodule add
  README_ROWS+=("${current_section_idx}|${url}|${local_path}|${description}")

  # ── Submodule registration ─────────────────────────────────────────────────
  if [[ -f ".gitmodules" ]] && grep -qF "path = $local_path" .gitmodules 2>/dev/null; then
    echo "  SKIP  (already registered): $local_path"
    (( skipped++ )) || true
    continue
  fi

  if [[ -d "$local_path/.git" ]]; then
    echo "  SKIP  (directory exists as git repo): $local_path"
    (( skipped++ )) || true
    continue
  fi

  echo "  ADD   $local_path"
  echo "        <- $url"

  if ! $DRY_RUN; then
    mkdir -p "$(dirname "$local_path")"
    if git submodule add -- "$url" "$local_path"; then
      (( added++ )) || true
    else
      echo "  ERROR adding submodule: $local_path" >&2
      (( errors++ )) || true
    fi
  else
    (( added++ )) || true
  fi

done < "$CSV_FILE"

echo ""
echo "Done.  Added: $added  |  Skipped: $skipped  |  Errors: $errors"

# ── Optional submodule update ─────────────────────────────────────────────────
if $DO_UPDATE && ! $DRY_RUN && [[ $added -gt 0 ]]; then
  echo ""
  echo "Running: git submodule update --init --recursive"
  git submodule update --init --recursive
fi

# ── README update ─────────────────────────────────────────────────────────────
if ! $UPDATE_README; then
  exit 0
fi

echo ""
echo "Updating README: $README_FILE"

# Build the replacement block ─────────────────────────────────────────────────
{
  printf '<!-- SUBMODULES:START -- auto-generated by add_submodules.sh, do not edit this block manually -->\n'
  printf '## Submodules\n\n'
  printf 'This repository contains **%d** submodule(s) organized by source.\n\n' "${#README_ROWS[@]}"
  printf 'To initialize after cloning:\n\n'
  printf '```bash\ngit submodule update --init --recursive\n```\n\n'

  prev_section=-2

  for row in "${README_ROWS[@]}"; do
    # Split the stored row
    sec_idx="${row%%|*}"
    rest="${row#*|}"
    url="${rest%%|*}"
    rest="${rest#*|}"
    local_path="${rest%%|*}"
    description="${rest#*|}"

    # Emit a new section heading + table header when section changes
    if [[ "$sec_idx" != "$prev_section" ]]; then
      [[ $prev_section -ge -1 ]] && printf '\n'

      # Get heading text
      section_name="Other"
      if [[ "$sec_idx" -ge 0 ]] 2>/dev/null && \
         [[ "$sec_idx" -lt "${#README_SECTIONS[@]}" ]] 2>/dev/null; then
        section_name="${README_SECTIONS[$sec_idx]}"
        # Strip leading/trailing box-drawing decorations
        section_name=$(printf '%s' "$section_name" \
          | sed 's/^[[:space:][:punct:]─—–]*//' \
          | sed 's/[[:space:][:punct:]─—–]*$//')
      fi

      printf '### %s\n\n' "$section_name"
      printf '| Repository | Path | Description |\n'
      printf '|---|---|---|\n'
      prev_section="$sec_idx"
    fi

    # Repo display name
    repo_name=$(basename "$url" .git)
    repo_name="${repo_name%/}"

    # Sanitize: pipe chars break Markdown tables
    safe_desc="${description//|/∣}"

    printf '| [`%s`](%s) | `%s` | %s |\n' \
      "$repo_name" "$url" "$local_path" "$safe_desc"
  done

  printf '\n<!-- SUBMODULES:END -->\n'
} > /tmp/_submodules_section.md

if $DRY_RUN; then
  echo ""
  echo "──────────── README section preview ────────────"
  cat /tmp/_submodules_section.md
  echo "─────────────────────────────────────────────────"
  rm /tmp/_submodules_section.md
  exit 0
fi

# Create README if it doesn't exist
if [[ ! -f "$README_FILE" ]]; then
  printf '# Adaptive Switches\n\nAn open-source collection of 3D-printable and DIY adaptive switches for assistive technology.\n\n' \
    > "$README_FILE"
fi

if grep -q '<!-- SUBMODULES:START' "$README_FILE" 2>/dev/null; then
  # Replace the existing block using awk
  awk '
    /<!-- SUBMODULES:START/ { in_block=1 }
    in_block && /<!-- SUBMODULES:END -->/ { in_block=0; next }
    !in_block { print }
  ' "$README_FILE" > "${README_FILE}.tmp"

  # Find line number just before the old block's position to insert cleanly
  # Simpler: just append new section after the filtered content
  cat /tmp/_submodules_section.md >> "${README_FILE}.tmp"
  mv "${README_FILE}.tmp" "$README_FILE"
  echo "  README section replaced."
else
  cat /tmp/_submodules_section.md >> "$README_FILE"
  echo "  README section appended."
fi

rm /tmp/_submodules_section.md
echo "  Done: $README_FILE"
