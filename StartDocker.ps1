Add-LocalGroupMember -Group "docker-users" -Member "NT AUTHORITY\SYSTEM"

Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
C:'\Program Files\'Docker\Docker'\Docker Desktop.exe'
Start-Sleep -Seconds 300
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine
& C:'\Program Files\'Docker\Docker\DockerCli.exe -SwitchWindowsEngine
$DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$StartupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DockerDesctop.lnk"
echo $DockerPath > "C:\Program Files\output.txt"
echo $StartupPath >> "C:\Program Files\output.txt"
whoami | Out-File -FilePath "C:\Program Files\output.txt"
echo $Env:ProgramFiles\Docker\Docker\DockerCli.exe >> "C:\Program Files\output.txt"
docker version >> "C:\Program Files\output.txt"


