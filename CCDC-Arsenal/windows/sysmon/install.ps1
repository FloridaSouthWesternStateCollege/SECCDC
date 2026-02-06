# File: CCDC-Arsenal/windows/sysmon/install.ps1
$ErrorActionPreference = "Stop"
Write-Host "[*] Starting Sysmon Deployment..." -ForegroundColor Cyan

# Get the directory where this script is running
$ScriptPath = $PSScriptRoot

# Define file paths
$SysmonExe = "$ScriptPath\Sysmon64.exe"
$SysmonConfig = "$ScriptPath\sysmon-config.xml"

# Install
if (Test-Path $SysmonExe) {
    Write-Host "[*] Installing Sysmon..."
    Start-Process -FilePath $SysmonExe -ArgumentList "-accepteula -i $SysmonConfig -h md5,sha256,imphash" -Verb RunAs -Wait
    Write-Host "[+] Sysmon Installed Successfully!" -ForegroundColor Green
} else {
    Write-Error "[-] Sysmon64.exe not found in $ScriptPath"
}