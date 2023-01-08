param(
    [string]$TestLabAdminUser = "Administrator",
    [string]$TestLabAdminPassword = "Pa55word",
    [string]$TestLabDomain = "maxxys.local",
    [string]$TestLabName = "TestLab",
    [string]$TestLabSecUser = "maxxys\Administrator",
    [string]$TestLabSecPwd = "Pa55word",
    [string]$TestLabVMPath = "C:\TestLabs"
)
#Preflight Activities
& "$PSscriptRoot\preinstall.ps1"

#Define TestLab
$TestLabVMPath = Join-Path $TestLabVMPath -ChildPath $ENV:COMPUTERNAME
Send-ALNotification -Activity "Preparing Test Lab" -Message " " -Provider Toast
New-LabDefinition -Name $TestLabName -DefaultVirtualizationEngine HyperV -VmPath $TestLabVMPath -ReferenceDiskSizeInGB 100

#Define TestLab Settings
Add-LabDomainDefinition -Name $TestLabDomain -AdminUser $TestLabAdminUser -AdminPassword $TestLabAdminPassword
Set-LabInstallationCredential -Username $TestLabAdminUser -Password $TestLabAdminPassword

#prepare lab computer names
$DC = $TestLabName + "DC01"
$SRV01 = $TestLabName + "SRV1"
$SRV02 = $TestLabName + "SRV2"
$PC01 = $TestLabName + "CLT1"
$PC02 = $TestLabName + "CLT2"
$PC03 = $TestLabName + "CLT3"

Send-ALNotification -Activity "Create Virtual Machines" -Message " " -Provider Toast
Add-LabMachineDefinition -Name $DC -OperatingSystem 'Windows Server 2022 STANDARD Evaluation (Desktop Experience)' -Roles RootDC -DomainName $TestLabDomain -TimeZone "W. Europe Standard Time" -SkipDeployment

#create Memberserver
Add-LabMachineDefinition -Name $SRV01 -OperatingSystem 'Windows Server 2022 STANDARD Evaluation (Desktop Experience)' -DomainName $TestLabDomain -TimeZone "W. Europe Standard Time" -Memory 2GB -MinMemory 512MB -MaxMemory 8GB -Processors 4 -SkipDeployment
Add-LabMachineDefinition -Name $SRV02 -OperatingSystem 'Windows Server 2022 STANDARD Evaluation (Desktop Experience)' -DomainName $TestLabDomain -TimeZone "W. Europe Standard Time" -Memory 2GB -MinMemory 512MB -MaxMemory 8GB -Processors 4
Add-LabMachineDefinition -Name $PC01 -OperatingSystem 'Windows 10 Enterprise Evaluation' -DomainName $TestLabDomain -TimeZone "W. Europe Standard Time" -Memory 1GB -MinMemory 512MB -MaxMemory 2GB -SkipDeployment
Add-LabMachineDefinition -Name $PC02 -OperatingSystem 'Windows 11 Enterprise Evaluation' -DomainName $TestLabDomain -TimeZone "W. Europe Standard Time" -Memory 1GB -MinMemory 512MB -MaxMemory 2GB -SkipDeployment

#Ensure Windows Defender does not slow down LAB build
Write-ScreenInfo -Message 'Setting Windows Defender Exclusions'
Set-MpPreference -ExclusionProcess dism.exe,code.exe,powershell.exe,powershell_ise.exe

#start building lab
Install-Lab

#Postinstall Actions
& "$PSScriptRoot\postinstall.ps1"