#!/usr/bin/env bash
# export_parts.sh
# Renders the lid, box, and tpu_base from electrocookie_box.scad as separate STLs.
# Usage: ./export_parts.sh [path/to/electrocookie_box.scad] [output_dir]

set -euo pipefail

SCAD_FILE="${1:-electrocookie_box.scad}"
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

render_part "lid"
render_part "box"
render_part "tpu_base"

echo ""
echo "All parts exported to: $OUT_DIR"
echo "  lid.stl"
echo "  box.stl"
echo "  tpu_base.stl"
