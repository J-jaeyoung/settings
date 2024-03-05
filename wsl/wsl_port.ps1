# $ports = @(1234);
$ports = $args
$scriptPath = $MyInvocation.MyCommand.Path
$count = 0

if ($args.Count -eq 0) {
    Write-Host "Usage: $scriptPath [port ...]" -ForegroundColor Red
    exit
}

foreach ($port in $ports) {
    Write-Host "[!] $port" -ForegroundColor Blue
    if (-not ($port -match '^(\d{1,5})$')) {
	        Write-Host "$port is not an port number" -ForegroundColor Red
		exit
    }
}

$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "WSL IP address: $wslAddress" -ForegroundColor Green
  Write-Host "Ports: $ports" -ForegroundColor Green
}
else {
  Write-Host "Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

$listenAddress = '0.0.0.0';

foreach ($port in $ports) {
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$listenAddress";
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$listenAddress connectport=$port connectaddress=$wslAddress";
}

$fireWallDisplayName = '__WSL Port Forwarding';
$portsStr = $ports -join ",";
Invoke-Expression "Remove-NetFireWallRule -DisplayName '__WSL Port Forwarding'";
if (Get-NetFireWallRule -DisplayName $fireWallDisplayName -ErrorAction SilentlyContinue) {
    Invoke-Expression "Remove-NetFireWallRule -DisplayName '__WSL Port Forwarding'";
}

Invoke-Expression "New-NetFireWallRule -DisplayName '__WSL Port Forwarding' -Direction Outbound -LocalPort $portsStr -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName '__WSL Port Forwarding' -Direction Inbound -LocalPort $portsStr -Action Allow -Protocol TCP";
