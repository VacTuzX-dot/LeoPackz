# LeoPack Installer Script (Optimized)

# Configuration
$AppName = "LeoPack"
$InstallDir = "$env:USERPROFILE\Downloads\$AppName"
# IMPORTANT: ตรวจสอบลิงก์นี้ให้ถูกต้องว่าเป็น Direct Link ของไฟล์ Zip
$ZipUrl = "https://github.com/VacTuzX-dot/LeoPackz/releases/download/v1.1/LeoPacks.zip" 

# ==========================================
# 1. Pre-flight Check: .NET Runtime (สำคัญมาก เพราะเราลบไฟล์ exe ออกแล้ว)
# ==========================================
Write-Host "Checking dependencies..." -ForegroundColor Cyan

# เช็คว่ามี .NET Desktop Runtime 8 หรือไม่ (แก้เลข 8. ตามเวอร์ชันที่คุณใช้)
$hasDotNet = dotnet --list-runtimes 2>$null | Select-String "Microsoft.WindowsDesktop.App 8."

if (-not $hasDotNet) {
    Write-Host "Required .NET 8 Desktop Runtime not found. Installing..." -ForegroundColor Yellow
    try {
        # ใช้ Winget โหลดตัว Runtime (ขนาดเล็ก) มาลง
        winget install Microsoft.DotNet.DesktopRuntime.8 --silent --accept-package-agreements --accept-source-agreements
        Write-Host ".NET Runtime installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install .NET Runtime automatically. Please install .NET 8 Desktop Runtime manually."
        # ไม่ exit เพราะบางที user อาจจะมีวิธีรันแบบอื่น หรือ winget error แต่มี runtime อยู่แล้ว
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
Write-Host "Downloading package from GitHub..."

try {
    # เทคนิค: ปิด Progress Bar ชั่วคราวเพื่อเร่งความเร็วการดาวน์โหลด (ใน PowerShell 5.1 ช่วยได้มาก)
    $OriginalProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath
    
    $ProgressPreference = $OriginalProgressPreference # คืนค่าเดิม
}
catch {
    Write-Error "Failed to download package. Please check your internet or the URL."
    exit 1
}

# ==========================================
# 4. Extract the Zip File
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
    
    # อัปเดต PATH ใน Session ปัจจุบันทันที (User ไม่ต้องปิดเปิดใหม่)
    $env:Path += ";$InstallDir"
    
    Write-Host "Path updated." -ForegroundColor Green
} else {
    Write-Host "Path already configured."
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host " $AppName installed successfully! " -ForegroundColor Green
Write-Host " Type '$AppName' (or your command name) to start."
Write-Host " Location: $InstallDir"
Write-Host "============================================" -ForegroundColor Cyan
