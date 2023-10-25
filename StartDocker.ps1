Add-LocalGroupMember -Group "docker-users" -Member "NT AUTHORITY\SYSTEM"


Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"

& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine
& C:'\Program Files\'Docker\Docker\DockerCli.exe -SwitchWindowsEngine
$DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$StartupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DockerDesctop.lnk"
echo $DockerPath > "C:\Program Files\output.txt"
echo $StartupPath >> "C:\Program Files\output.txt"
whoami | Out-File -FilePath "C:\Program Files\output.txt"
echo $Env:ProgramFiles\Docker\Docker\DockerCli.exe >> "C:\Program Files\output.txt"
docker version >> "C:\Program Files\output.txt"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($StartupPath)
$Shortcut.TargetPath = $DockerPath
$Shortcut.Save()

