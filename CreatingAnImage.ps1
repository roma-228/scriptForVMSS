
$imageResourceGroup = 'creatingTemplateImages'
$location = 'WestEurope'
$subscriptionID = (Get-AzContext).Subscription.Id
$WinServer2022 = "https://raw.githubusercontent.com/roma-228/scriptForVMSS/main/Win10MultiAppsTemplate.json"
$WinServer2022FileName = "WinSer2022Template.json"

if ((test-path .\Template) -eq $false) {
    new-item -ItemType Directory -name 'Template'
} 
if ((test-path .\Template\$WinServer2022FileName) -eq $true) {
    $confirmation = Read-Host "Are you Sure You Want to Replace the Template?:"
    if ($confirmation -eq 'y' -or $confirmation -eq 'yes' -or $confirmation -eq 'Yes') {
        Invoke-WebRequest -Uri $WinServer2022 -OutFile ".\Template\$WinServer2022FileName" -UseBasicParsing
    }
} else {
    Invoke-WebRequest -Uri $WinServer2022 -OutFile ".\Template\$WinServer2022FileName" -UseBasicParsing
}


$imageResourceGroup = 'creatingTemplateImages'
$location = (Get-AzResourceGroup -Name $imageResourceGroup).Location
$subscriptionID = (Get-AzContext).Subscription.Id
$installScript = 'https://raw.githubusercontent.com/roma-228/scriptForVMSS/main/Install-Applications.ps1'
$installScriptForChangeDeamon = 'https://raw.githubusercontent.com/roma-228/scriptForVMSS/main/DaemonChangeForDocker.ps1'
$imageName = 'CustomImgWinServer2022'
$imageTemplateName = 'imageTemplateWinServer2022Multi'
$runOutputName = 'WinServer2022Client'
$templateFilePath = ".\Template\$WinServer2022FileName"
$identityName = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup).Name
$identityNameResourceId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id

((Get-Content -path $templateFilePath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<rgName>',$imageResourceGroup) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<region>',$location) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<runOutputName>',$runOutputName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imageName>',$imageName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$identityNameResourceId) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<URI to PowerShell Script>',$installScript ) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<URI to PowerShell Script daemon change for docker>',$installScriptForChangeDeamon ) | Set-Content -Path $templateFilePath



# Install the PowerShell module if not already installed
Install-Module -name 'Az.ImageBuilder' -AllowPrerelease

New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath `
-api-version "2023-07-01" -imageTemplateName $imageTemplateName -svclocation $location

Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup |
Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState, ProvisioningErrorMessage

Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName
