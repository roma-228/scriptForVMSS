Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
& $Env:ProgramFiles\\Docker\\Docker\\DockerCli.exe -SwitchWindowsEngine

$DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$StartupPath = [Environment]::GetFolderPath("Startup")

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$StartupPath\Docker Desktop.lnk")
$Shortcut.TargetPath = $DockerPath
$Shortcut.Save()

