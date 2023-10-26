Add-LocalGroupMember -Group "docker-users" -Member "NT AUTHORITY\SYSTEM"

$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$Name = "Docker Desktop1"
$Value = "C:\Program Files\Docker\Docker\Docker Desktop.exe -Autostart"
Set-ItemProperty -Path $Path -Name $Name -Value $Value

$Username = 'NewUser2'
$Password = ConvertTo-SecureString 'Password123' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($Username, $Password)
New-LocalUser -Name $Credential.UserName -Password $Credential.Password -FullName 'Full Name' -Description 'Description of the user'
Add-LocalGroupMember -Group "docker-users" -Member $Username
$FilePath = "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
Start-Process -FilePath $FilePath -Credential $Credential
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine -Credential $Credential
