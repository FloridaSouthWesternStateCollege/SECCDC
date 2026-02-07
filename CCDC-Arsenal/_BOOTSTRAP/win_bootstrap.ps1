# File: CCDC-Arsenal/_BOOTSTRAP/win_bootstrap.ps1
# Usage: Execute this on the victim machine via PowerShell
# Example: Invoke-WebRequest "http://YOUR_IP/_BOOTSTRAP/win_bootstrap.ps1" -OutFile run.ps1; .\run.ps1

$ServerIP = "192.168.1.50"  # <--- YOU MUST UPDATE THIS ON GAME DAY TO YOUR LAPTOP IP
$BaseURL = "http://$ServerIP"

Write-Host "=== CCDC DEFENSE PROTOCOL INITIATED ===" -ForegroundColor Magenta

# 1. Create a Temp Directory
$WorkDir = "C:\CCDC_Tools"
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
cd $WorkDir

# 2. Pull and Run Sysmon
Write-Host "[-] Fetching Sysmon..."
Invoke-WebRequest -Uri "$BaseURL/windows/sysmon/Sysmon64.exe" -OutFile "Sysmon64.exe"
Invoke-WebRequest -Uri "$BaseURL/windows/sysmon/sysmon-config.xml" -OutFile "sysmon-config.xml"
Invoke-WebRequest -Uri "$BaseURL/windows/sysmon/install.ps1" -OutFile "install_sysmon.ps1"
.\install_sysmon.ps1

# 3. Pull and Run Wazuh
Write-Host "[-] Fetching Wazuh..."
Invoke-WebRequest -Uri "$BaseURL/windows/wazuh-agent/wazuh-agent.msi" -OutFile "wazuh-agent.msi"
Invoke-WebRequest -Uri "$BaseURL/windows/wazuh-agent/deploy.ps1" -OutFile "deploy_wazuh.ps1"
.\deploy_wazuh.ps1 -ManagerIP "10.10.10.5" # UPDATE THIS TO YOUR WAZUH SERVER IP

Write-Host "=== DEFENSE DEPLOYMENT COMPLETE ===" -ForegroundColor Magenta