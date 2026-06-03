#!/bin/bash

# export_nudge_switch.sh
SCAD_FILE="NudgeSwitch_Unified.scad"

# Define the variants and parts
PROFILES=("standard" "low_profile")
PARTS=("body" "switch_base" "button_top" "cap" "spring")

# Check if openscad is installed
if ! command -v openscad &> /dev/null; then
    echo "Error: openscad command not found. Please ensure it is in your PATH."
    exit 1
fi

for PROFILE in "${PROFILES[@]}"; do
    echo "--- Processing Profile: $PROFILE ---"
    
    # Create directory for clean organization
    OUTPUT_DIR="Exports_${PROFILE}"
    mkdir -p "$OUTPUT_DIR"

    for PART in "${PARTS[@]}"; do
        OUTPUT_FILE="${OUTPUT_DIR}/NudgeSwitch_${PROFILE}_${PART}.stl"
        echo "Exporting $PART to $OUTPUT_FILE..."
        
        # Run OpenSCAD in the background for faster processing
        openscad -o "$OUTPUT_FILE" -D "switch_type=\"$PROFILE\"" -D "part=\"$PART\"" "$SCAD_FILE" &
    done
    wait # Wait for all parts in the current profile to finish before starting the next
done

echo "Export Complete!"