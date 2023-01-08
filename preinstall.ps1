Send-ALNotification -Activity "Preflight Actions" -Message " " -Provider Toast
Write-ScreenInfo -Message "Starting preflight actions" -TaskStart
$ISOPath = Join-Path -Path $PSScriptRoot -ChildPath "ISO"
$ISOs = Join-Path -Path $labSources -ChildPath "ISOs"
#DL URL Server 2022 Eval
$s2k22ISODownLoadURL = "https://go.microsoft.com/fwlink/p/?LinkID=2195280&clcid=0x409&culture=en-us&country=US"
$s2k22ISOFileName = "SERVER_EVAL_x64FRE_en-us.iso"

#DL URL Server 2019 Eval
#$ISODownLoadURL = "https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US"
#$ISOFileName = "17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"

#DL URL Windows 11 Eval
#$w11ISODownLoadURL = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
#$w11ISOFileName = "22000.318.211104-1236.co_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"

#DL URL Windows 10 Eval
$w10ISODownLoadURL = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
$w10ISOFileName = "19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"


#Check if Server 2022 Eval ISO exist
$S2k22Iso = Join-Path $ISOs -ChildPath $s2k22ISOFileName
$IsoExist = Test-Path -Path $S2k22Iso -PathType Leaf
If (!($IsoExist)){
    $ISOObj = Get-LabInternetFile -Uri $s2k22ISODownloadURL -Path $ISOs -FileName $s2k22ISOFileName -PassThru -ErrorAction "Stop" -ErrorVariable "GetLabInternetFileErr"
    Remove-Variable -Name ISOObj
}
Remove-Variable -Name IsoExist

#Check if Windows 10 Eval ISO exist
$w10Iso = Join-Path $ISOs -ChildPath $w10ISOFileName
$IsoExist = Test-Path -Path $w10Iso -PathType Leaf
If (!($IsoExist)){
    $ISOObj = Get-LabInternetFile -Uri $w10ISODownloadURL -Path $ISOs -FileName $w10ISOFileName -ErrorAction "Stop" -ErrorVariable "GetLabInternetFileErr"    
    #Invoke-WebRequest -Uri $w10ISODownLoadURL -OutFile $w10Iso
    Remove-Variable -Name ISOObj
}
Remove-Variable -Name IsoExist

Write-ScreenInfo -Message "End preflight actions" -TaskStart