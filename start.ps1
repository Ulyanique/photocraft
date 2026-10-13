param (
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\start.ps1"
    Write-Host "Builds PhotoCraft (if needed) and starts the app."
    Exit
}

$exePath = "target\release\photocraft.exe"

# If the executable doesn't exist, try building it first
if (-not (Test-Path $exePath)) {
    Write-Host "Executable not found. Running build.ps1 first..."
    .\build.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed. Cannot start the app."
        Exit $LASTEXITCODE
    }
}

Write-Host "Starting PhotoCraft..."
Start-Process -FilePath $exePath -NoNewWindow -Wait
