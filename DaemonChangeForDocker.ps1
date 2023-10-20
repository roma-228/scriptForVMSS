#region daemon change for docker
Write-Host 'start process reload!'
Write-Host 'start swith deamon docker!'

docker version

Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
Start-Sleep -Seconds 300

& $Env:ProgramFiles\\Docker\\Docker\\DockerCli.exe -SwitchWindowsEngine

docker version
#endregion

#region adding docker to startup folder
cd $HOME
ls
Write-Host 'folder $HOME!'

cd AppData
ls 
Write-Host 'folder AppData!'

cd Roaming
ls 
Write-Host 'folder Roaming!'

cd Microsoft
ls 
Write-Host 'folder Microsoft!'

cd Windows
ls 
Write-Host 'folder Windows!'

cd '.\Start Menu\'
ls 
Write-Host 'folder Start Menu!'

cd Programs
ls 
Write-Host 'folder Programs!'

cd Startup
ls 
Write-Host 'folder Startup!'

$pathtostartuptest = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
if ((Test-Path $pathtostartuptest)) {
    Write-Host 'folder startup!'
}
cd "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
pwd
$pathtostartup = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\DockerDesktop.lnk"
$pathtodocker = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($pathtostartup)
$Shortcut.TargetPath = $pathtodocker
$Shortcut.Save()
#endregion

# Fix for first login delays due to Windows Module Installer
try {
    ((Get-Content -path C:\DeprovisioningScript.ps1 -Raw) -replace 'Sysprep.exe /oobe /generalize /quiet /quit', 'Sysprep.exe /oobe /generalize /quit /mode:vm' ) | Set-Content -Path C:\DeprovisioningScript.ps1
    write-log "Sysprep Mode:VM fix applied"
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error updating script: $ErrorMessage"
}
#endregion

#region Time Zone Redirection
$Name = "fEnableTimeZoneRedirection"
$value = "1"
# Add Registry value
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name $name -Value $value -PropertyType DWORD -Force
    if ((Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services").PSObject.Properties.Name -contains $name) {
        Write-log "Added time zone redirection registry key"
    }
    else {
        write-log "Error locating the Teams registry key"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding teams registry KEY: $ErrorMessage"
}
#endregion
