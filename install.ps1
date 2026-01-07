# LeoPack Installer Script (Updated v1.1)

# Configuration
$AppName = "LeoPack"
$InstallDir = "$env:USERPROFILE\Downloads\$AppName"
# [UPDATE] ลิงก์ตรงนี้เปลี่ยนเป็น v1.1 แล้ว
$ZipUrl = "https://github.com/VacTuzX-dot/LeoPackz/releases/download/v1.1/LeoPacks.zip" 

# ==========================================
# 1. Pre-flight Check: .NET Runtime
# ==========================================
Write-Host "Checking dependencies..." -ForegroundColor Cyan

# เช็คว่ามี .NET Desktop Runtime 8 หรือไม่
$hasDotNet = dotnet --list-runtimes 2>$null | Select-String "Microsoft.WindowsDesktop.App 8."

if (-not $hasDotNet) {
    Write-Host "Required .NET 8 Desktop Runtime not found. Installing..." -ForegroundColor Yellow
    try {
        # ใช้ Winget โหลดตัว Runtime (ขนาดเล็ก) มาลงให้อัตโนมัติ
        winget install Microsoft.DotNet.DesktopRuntime.8 --silent --accept-package-agreements --accept-source-agreements
        Write-Host ".NET Runtime installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install .NET Runtime automatically. Please install .NET 8 Desktop Runtime manually."
    }
} else {
    Write-Host ".NET Runtime is already installed." -ForegroundColor Green
}

# ==========================================
# 2. Check/Create Installation Directory
# ==========================================
if (Test-Path $InstallDir) {
    Write-Host "Cleaning up existing installation..." -ForegroundColor Yellow
    Remove-Item -Path $InstallDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# ==========================================
# 3. Download the Zip File
# ==========================================
$ZipPath = "$env:TEMP\LeoPacks.zip"
Write-Host "Downloading package v1.1 from GitHub..."

try {
    # ปิด Progress Bar ชั่วคราวเพื่อเร่งความเร็ว (สำคัญมากสำหรับไฟล์ใหญ่)
    $OriginalProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath
    
    $ProgressPreference = $OriginalProgressPreference
}
catch {
    Write-Error "Failed to download package. Please check if 'LeoPacks.zip' exists in Release v1.1."
    exit 1
}

# ==========================================
# 4. Extract and Clean up
# ==========================================
Write-Host "Extracting files..."
try {
    Expand-Archive -Path $ZipPath -DestinationPath $InstallDir -Force
    Remove-Item $ZipPath -Force
}
catch {
    Write-Error "Failed to extract package."
    exit 1
}

# ==========================================
# 5. Add to PATH & Refresh Session
# ==========================================
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host "Adding $AppName to PATH..."
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    $env:Path += ";$InstallDir"
    Write-Host "Path updated." -ForegroundColor Green
} else {
    Write-Host "Path already configured."
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host " LeoPack v1.1 installed successfully! " -ForegroundColor Green
Write-Host " Type your command to start."
Write-Host " Location: $InstallDir"
Write-Host "============================================" -ForegroundColor Cyan
