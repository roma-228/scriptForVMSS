# Software install Script

#region Set logging 
$logFile = "c:\temp\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}
#endregion

#region Install choco+git
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
choco install git --force --params "/NoAutoCrlf"
#endregion

#region DockerDesktop
#cd C:\Temp
#wget https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe -O "Docker Desktop Installer.exe"
Write-Host 'start process install docker!'
Start-Process -Wait -NoNewWindow -FilePath "c:\temp\Docker Desktop Installer.exe" -ArgumentList "install --backend=hyper-v --quiet --accept-license " -ErrorAction Stop;
Write-Host 'finish process install docker!'
#endregion
