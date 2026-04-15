# Path to OpenSCAD executable
$openscad = "C:\Program Files\OpenSCAD (Nightly)\openscad.exe"

# Input SCAD file
$input = "switch.scad"

# JSON parameter file
$json = "export_parts.json"

# Output directory
$outputDir = "stl"

# Ensure output directory exists
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

# Parts to export
$parts = @("body", "switch_base", "flexure_spring", "button_top", "cap")

foreach ($part in $parts) {
    $output = Join-Path $outputDir "$part.stl"

    Write-Host "Exporting $part..."

    & $openscad `
        -o $output `
        --enable=manifold `
        --export-format=stl `
        -P $part `
        -p $json `
        $input
}