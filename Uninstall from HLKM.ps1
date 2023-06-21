$SoftwareName = 'Microsoft SQL Server'

$RegPath1 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'

$RegPath2 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'

# Path for log file
$LogFile = 'C:\Windows\Temp\Uninstall_SSMS_Log.txt'

# Time stamp for log file
$TimeStamp = Get-Date -Format 'MM-dd-yyyy_HH-mm-ss'

$SQLVer = (Get-ChildItem -Path $RegPath1,$RegPath2 | Get-ItemProperty | Where-Object { $_.DisplayName -match $SoftwareName }) | Select-Object DisplayName, UninstallString


foreach ($v in $SQLVer) {
    Write-Host $v
}


<#
if ($null -ne $SQLVer) {

    foreach ($Ver in $SQLVer) {

	# Get rid of /uninstall and surrounding quoation marks in UnintsallString
        $Ver = $Ver -replace ('/uninstall','') -replace ('"','')

        $Process = Start-Process -FilePath $Ver -ArgumentList '/uninstall /quiet /norestart' -PassThru
        Wait-Process -InputObject $Process

        # switch statement - similar to using if/else block
        switch ($Process.ExitCode) {
            0 {
                Out-File -FilePath $LogFile -InputObject "$($TimeStamp): $env:COMPUTERNAME | $Ver | ExitCode:0 | Success"
            }
            Default {
                Out-File -FilePath $LogFile -InputObject "$($TimeStamp): $env:COMPUTERNAME | $Ver | ExitCode:$($Process.ExitCode) | Fail"
            }

        } # end switch

    } # end foreach

} # end if $null


# No uninstall strings were found
else {
    Out-File -FilePath $LogFile -InputObject "$($TimeStamp): $env:COMPUTERNAME | No uninstall strings found for $SoftwareName"
}
#>