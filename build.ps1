param (
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\build.ps1"
    Write-Host "Installs Rust (if missing) and compiles PhotoCraft in release mode."
    Exit
}

# 1. Check for Rust and MSVC C++ tools
$rustcExists = Get-Command "rustc" -ErrorAction SilentlyContinue
if (-not $rustcExists) {
    Write-Host "Rust is not installed. Installing Rust..."
    # Download and run rustup-init for Windows
    Invoke-WebRequest -Uri "https://win.rustup.rs" -OutFile "rustup-init.exe"
    Write-Host "Please follow the prompts to install Rust (default settings are recommended)."
    Start-Process -FilePath "rustup-init.exe" -Wait -NoNewWindow
    Remove-Item "rustup-init.exe"

    # Reload environment variables in current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Ensure rustc is available after potential installation
$rustcExists = Get-Command "rustc" -ErrorAction SilentlyContinue
if (-not $rustcExists) {
    Write-Error "Rust installation failed or requires a terminal restart. Please restart your terminal and run build.ps1 again."
    Exit 1
}

# 2. Check rust version (needs 1.95+)
# For simplicity, we just run update to make sure it's up to date.
Write-Host "Updating Rust to the latest stable version..."
rustup update stable

# 3. Build the project
Write-Host "Building PhotoCraft (Release)... This might take a few minutes."
cargo build --release -p photocraft

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful! Executable is located at: target/release/photocraft.exe" -ForegroundColor Green
} else {
    Write-Error "Build failed with exit code $LASTEXITCODE"
    Exit $LASTEXITCODE
}
