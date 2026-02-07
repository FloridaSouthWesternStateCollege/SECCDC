# File: CCDC-Arsenal/windows/wazuh-agent/deploy.ps1
param([string]$ManagerIP = "10.0.0.5") # CHANGE THIS IP DURING COMPETITION

Write-Host "[*] Deploying Wazuh Agent pointing to $ManagerIP..." -ForegroundColor Cyan

$Installer = "$PSScriptRoot\wazuh-agent.msi"

if (Test-Path $Installer) {
    # Run the MSI silently
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $Installer /q WAZUH_MANAGER='$ManagerIP'" -Wait
    
    # Start the service
    Start-Service -Name "WazuhSvc"
    Write-Host "[+] Wazuh Agent Installed and Started!" -ForegroundColor Green
} else {
    Write-Error "[-] wazuh-agent.msi not found!"
}