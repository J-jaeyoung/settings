$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "WSL IP address: $wslAddress" -ForegroundColor Green
}
else {
  Write-Host "Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

Invoke-Expression "netsh interface portproxy reset"

$fireWallDisplayName = '__WSL Port Forwarding';
$portsStr = $ports -join ",";
if (Get-NetFireWallRule -DisplayName $fireWallDisplayName -ErrorAction SilentlyContinue) {
    Invoke-Expression "Remove-NetFireWallRule -DisplayName '__WSL Port Forwarding'";
}
