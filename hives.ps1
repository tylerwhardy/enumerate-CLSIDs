#-------------------------------------------------------------------
# Copy-BypassOpen.ps1
#-------------------------------------------------------------------
param(
  [string]$SourceHive,    # e.g. 'C:\Windows\System32\config\SAM'
  [string]$DestHive,      # e.g. 'C:\Users\DSU\Documents\SAM.hiv'
  [int]   $BufferSize = 4MB
)

# open the locked file with the "backup semantics" flag
$inStream = [System.IO.FileStream]::new(
    $SourceHive,
    [System.IO.FileMode]     ::Open,
    [System.IO.FileAccess]    ::Read,
    [System.IO.FileShare]     ::ReadWrite,
    $BufferSize,
    [System.IO.FileOptions]   ::BackupSemantics
)

# create the output file
$outStream = [System.IO.File]::Create($DestHive)

# copy
$inStream.CopyTo($outStream)

# clean up
$inStream.Close()
$outStream.Close()

Write-Host "Copied $SourceHive → $DestHive"
