#!/bin/bash

OPENSCAD=openscad
INPUT="switch.scad"
JSON="export_parts.json"
OUTPUT_DIR="stl"

mkdir -p "$OUTPUT_DIR"

PARTS=("body" "switch_base" "flexure_spring" "button_top" "cap")

for PART in "${PARTS[@]}"; do
    OUTPUT="$OUTPUT_DIR/$PART.stl"

    echo "Exporting $PART..."

    $OPENSCAD \
        -o "$OUTPUT" \
        --enable=manifold \
        --export-format=stl \
        -P "$PART" \
        -p "$JSON" \
        "$INPUT"
done