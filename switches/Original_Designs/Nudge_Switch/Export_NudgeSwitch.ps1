# Export-NudgeSwitch.ps1
$ScadFile = "NudgeSwitch_Unified.scad"

# Define possible installation paths for OpenSCAD
$PossiblePaths = @(
    "C:\Program Files\OpenSCAD\openscad.exe",
    "C:\Program Files\OpenSCAD (Nightly)\openscad.exe"
)

$OpenScadPath = $null
foreach ($Path in $PossiblePaths) {
    if (Test-Path $Path) {
        $OpenScadPath = $Path
        break 
    }
}

if ($null -eq $OpenScadPath) {
    Write-Host "ERROR: OpenSCAD not found." -ForegroundColor Red
    exit
}

$Profiles = @("standard", "low_profile")
$Parts = @("body", "switch_base", "button_top", "cap", "spring")

foreach ($Profile in $Profiles) {
    Write-Host "`n--- Starting Profile: $Profile ---" -ForegroundColor Cyan
    
    # Map "standard" profile to the "high_profile" folder name
    if ($Profile -eq "standard") {
        $OutputDir = "high_profile"
    } else {
        $OutputDir = "low_profile"
    }

    if (-not (Test-Path $OutputDir)) { 
        New-Item -ItemType Directory -Path $OutputDir | Out-Null
    }

    foreach ($Part in $Parts) {
        $OutputFile = "$OutputDir/NudgeSwitch_${Profile}_${Part}.stl"
        Write-Host "  > Exporting Part: $Part" -NoNewline
        
        # FIX: Added a backslash (\) before the backtick-quote (`")
        # This forces Windows to pass literal quotes into OpenSCAD.
        $ArgList = @(
            "-o", $OutputFile,
            "-D", "switch_type=\`"$Profile\`"",
            "-D", "part=\`"$Part\`"",
            $ScadFile
        )

        Start-Process -FilePath $OpenScadPath -ArgumentList $ArgList -Wait -NoNewWindow
        
        Write-Host " [DONE]" -ForegroundColor Gray
    }
    Write-Host "--- Finished Profile: $Profile ---" -ForegroundColor Cyan
}

Write-Host "`n===============================" -ForegroundColor Green
Write-Host "ALL EXPORTS COMPLETE!" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green