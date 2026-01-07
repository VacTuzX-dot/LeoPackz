# LeoPack Installer Script

# Configuration
$AppName = "LeoPack"
$InstallDir = "$env:LOCALAPPDATA\$AppName"
# IMPORTANT: Replace this URL with the direct link to your LeoPacks.zip file
# Example: "https://github.com/YourUser/YourRepo/releases/download/v1.0/LeoPacks.zip"
$ZipUrl = "YOUR_DIRECT_DOWNLOAD_LINK_HERE" 

Write-Host "Installing $AppName..." -ForegroundColor Cyan

# 1. Check/Create Installation Directory
if (Test-Path $InstallDir) {
    Write-Host "Cleaning up existing installation..." -ForegroundColor Yellow
    Remove-Item -Path $InstallDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# 2. Download the Zip File
$ZipPath = "$env:TEMP\LeoPacks.zip"
Write-Host "Downloading package from $ZipUrl..."
try {
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath
}
catch {
    Write-Error "Failed to download package. Please check the URL."
    exit 1
}

# 3. Extract the Zip File
Write-Host "Extracting files..."
try {
    Expand-Archive -Path $ZipPath -DestinationPath $InstallDir -Force
    # Clean up zip
    Remove-Item $ZipPath
}
catch {
    Write-Error "Failed to extract package."
    exit 1
}

# 4. Add to PATH (User Environment Variable)
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host "Adding $AppName to PATH..."
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    Write-Host "Path updated. You may need to restart your terminal." -ForegroundColor Green
} else {
    Write-Host "Path already configured."
}

Write-Host "$AppName installed successfully!" -ForegroundColor Green
Write-Host "Installation location: $InstallDir"
