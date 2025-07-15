New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

$CLSID = Get-ItemProperty HKCR:\clsid\* |
    Select-Object AppID, @{Name='CLSID';Expression={$_.PSChildName}} |
    Where-Object { $_.AppID -ne $null }

foreach ($a in $CLSID) {
    Write-Host $a.CLSID
}
