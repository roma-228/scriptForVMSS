Add-LocalGroupMember -Group "docker-users" -Member "NT AUTHORITY\SYSTEM"

$Username = 'NewUser1'
$Password = ConvertTo-SecureString 'Password123' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($Username, $Password)
New-LocalUser -Name $Credential.UserName -Password $Credential.Password -FullName 'Full Name' -Description 'Description of the user'
Add-LocalGroupMember -Group "docker-users" -Member $Username
$FilePath = "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
Start-Process -FilePath $FilePath -Credential $Credential
Start-Process -FilePath $FilePath -Credential $Credential
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine -Credential $Credential


Start-Process -FilePath "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine
$DockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$StartupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\DockerDesctop.lnk"
echo $DockerPath > "C:\Program Files\output.txt"
echo $StartupPath >> "C:\Program Files\output.txt"
whoami | Out-File -FilePath "C:\Program Files\output.txt"
echo $Env:ProgramFiles\Docker\Docker\DockerCli.exe >> "C:\Program Files\output.txt"
docker version >> "C:\Program Files\output.txt"


