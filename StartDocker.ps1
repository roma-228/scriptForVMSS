Add-LocalGroupMember -Group "docker-users" -Member "NT AUTHORITY\SYSTEM"

$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-Command {Start-Process -FilePath 'C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe'; & '$Env:ProgramFiles\\Docker\\Docker\\DockerCli.exe' -SwitchWindowsEngine}"
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId "AzDevOps" -LogonType ServiceAccount
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Run Docker Desktop1" -Description "Start Docker Desktop for AzDevOps" -Principal $Principal


Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine
$DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$StartupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DockerDesctop.lnk"
echo $DockerPath > "C:\Program Files\output.txt"
echo $StartupPath >> "C:\Program Files\output.txt"
whoami | Out-File -FilePath "C:\Program Files\output.txt"
echo $Env:ProgramFiles\Docker\Docker\DockerCli.exe >> "C:\Program Files\output.txt"
docker version >> "C:\Program Files\output.txt"


