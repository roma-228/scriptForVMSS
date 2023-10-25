start-service -Name com.docker.service
start "C:\Program Files\Docker\Docker\Docker Desktop.exe"

Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
& $Env:ProgramFiles\\Docker\\Docker\\DockerCli.exe -SwitchWindowsEngine

$DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$StartupPath = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\DockerDesktop.lnk"
echo $DockerPath > "C:\Program Files\output.txt"
echo $StartupPath >> "C:\Program Files\output.txt"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $DockerPath
$Shortcut.Save()

