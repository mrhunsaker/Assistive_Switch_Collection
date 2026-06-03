#!/usr/bin/env bash
# export_hex_switch_parts.sh
# Renders the cap and body from hex_switch.scad as separate STLs.
# Usage: ./export_hex_switch_parts.sh [path/to/hex_switch.scad] [output_dir]

set -euo pipefail

SCAD_FILE="${1:-hex_switch.scad}"
OUT_DIR="${2:-.}"

# Verify openscad is available
if ! command -v openscad &>/dev/null; then
    echo "Error: openscad not found. Install it with:  sudo apt install openscad"
    exit 1
fi

mkdir -p "$OUT_DIR"

render_part() {
    local part_name="$1"
    local out_file="$OUT_DIR/${part_name}.stl"
    echo "Rendering: $part_name  →  $out_file"
    openscad \
        -o "$out_file" \
        -D "part=\"${part_name}\"" \
        "$SCAD_FILE"
    echo "  Done: $out_file"
}

render_part "cap"
render_part "body"

echo ""
echo "All parts exported to: $OUT_DIR"
echo "  cap.stl"
echo "  body.stl"
