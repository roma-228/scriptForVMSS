# Software install Script

#region Set logging 
$logFile = "c:\temp\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}
#endregion

#region Install choco+git
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
choco install git --force --params "/NoAutoCrlf"
#endregion

#region DockerDesktop
function Start-DownloadWithRetry
{
    Param
    (
        [Parameter(Mandatory)]
        [string] $Url,
        [string] $Name,
        [string] $DownloadPath = "${env:Temp}",
        [int] $Retries = 20
    )

    if ([String]::IsNullOrEmpty($Name)) {
        $Name = [IO.Path]::GetFileName($Url)
    }

    $filePath = Join-Path -Path $DownloadPath -ChildPath $Name
    $downloadStartTime = Get-Date

    # Default retry logic for the package.
    while ($Retries -gt 0)
    {
        try
        {
            $downloadAttemptStartTime = Get-Date
            Write-Host "Downloading package from: $Url to path $filePath ."
            (New-Object System.Net.WebClient).DownloadFile($Url, $filePath)
            break
        }
        catch
        {
            $failTime = [math]::Round(($(Get-Date) - $downloadStartTime).TotalSeconds, 2)
            $attemptTime = [math]::Round(($(Get-Date) - $downloadAttemptStartTime).TotalSeconds, 2)
            Write-Host "There is an error encounterd after $attemptTime seconds during package downloading:`n $_"
            $Retries--

            if ($Retries -eq 0)
            {
                Write-Host "File can't be downloaded. Please try later or check that file exists by url: $Url"
                Write-Host "Total time elapsed $failTime"
                exit 1
            }

            Write-Host "Waiting 30 seconds before retrying. Retries left: $Retries"
            Start-Sleep -Seconds 30
        }
    }

    $downloadCompleteTime = [math]::Round(($(Get-Date) - $downloadStartTime).TotalSeconds, 2)
    Write-Host "Package downloaded successfully in $downloadCompleteTime seconds"
    return $filePath
}
#endregion
Function Get-DockerWincredHash
{
 Param (
    [Parameter(Mandatory = $True)]
    [string] $Release
)

 $hashURL = "https://github.com/docker/docker-credential-helpers/releases/download/${Release}/checksums.txt "
 (Invoke-RestMethod -Uri $hashURL).ToString().Split("`n").Where({ $_ -ilike "*docker-credential-wincred-${Release}.windows-amd64.exe*" }).Split(' ')[0]

}
#endregion

Write-Host "Get latest Moby release"
$mobyLatestReleaseVersion = (Invoke-RestMethod -Uri "https://api.github.com/repos/moby/moby/releases/latest").tag_name.Trim("v")
$dockerceUrl = "https://download.docker.com/win/static/stable/x86_64/"
$dockerceBinaries = Invoke-WebRequest -Uri $dockerceUrl -UseBasicParsing

Write-Host "Check Moby version $mobyLatestReleaseVersion"
$mobyRelease = $dockerceBinaries.Links.href -match "${mobyLatestReleaseVersion}\.zip" | Select-Object -Last 1
if (-not $mobyRelease) {
    Write-Host "Release not found for $mobyLatestRelease version"
    $versions = [regex]::Matches($dockerceBinaries.Links.href, "docker-(\d+\.\d+\.\d+)\.zip") | Sort-Object { [version]$_.Groups[1].Value }
    $mobyRelease = $versions | Select-Object -ExpandProperty Value -Last 1
    Write-Host "Found $mobyRelease"
}
$mobyReleaseUrl = $dockerceUrl + $mobyRelease

Write-Host "Install Moby $mobyRelease..."
$mobyArchivePath = Start-DownloadWithRetry -Url $mobyReleaseUrl -Name $mobyRelease
Expand-Archive -Path $mobyArchivePath -DestinationPath $env:TEMP
$dockerPath = "$env:TEMP\docker\docker.exe"
$dockerdPath = "$env:TEMP\docker\dockerd.exe"

Write-Host "Install Docker CE"
$instScriptUrl = "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1"
$instScriptPath = Start-DownloadWithRetry -Url $instScriptUrl -Name "install-docker-ce.ps1"
& $instScriptPath -DockerPath $dockerPath -DockerDPath $dockerdPath
if ($LastExitCode -ne 0) {
    Write-Host "Docker installation failed with exit code $LastExitCode"
    exit $exitCode
}

# Fix AZ CLI DOCKER_COMMAND_ERROR
# cli.azure.cli.command_modules.acr.custom: Could not run 'docker.exe' command.
# https://github.com/Azure/azure-cli/issues/18766
New-Item -ItemType SymbolicLink -Path "C:\Windows\SysWOW64\docker.exe" -Target "C:\Windows\System32\docker.exe"
