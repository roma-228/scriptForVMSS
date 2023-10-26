[Environment]::SetEnvironmentVariable("docker", "C:\Program Files\docker\docker.exe", "Machine")
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$newPath = $envPath + ";C:\Program Files\docker"
[Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
