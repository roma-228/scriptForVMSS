Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
& $Env:ProgramFiles\\Docker\\Docker\\DockerCli.exe -SwitchWindowsEngine
Set-Service -Name com.docker.service -StartupType Automatic
