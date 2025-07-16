param(
    [string] $SourceHive,
    [string] $DestHive,
    [int]    $BufferSize = 4MB
)

# Open the locked hive using BackupSemantics
$inStream = [System.IO.FileStream]::new(
    $SourceHive,
    [System.IO.FileMode]      ::Open,
    [System.IO.FileAccess]    ::Read,
    [System.IO.FileShare]     ::ReadWrite,
    $BufferSize,
    [System.IO.FileOptions]   ::BackupSemantics
)

# Create the destination file
$outStream = [System.IO.File]::Create($DestHive)

# Copy the contents
$inStream.CopyTo($outStream)

# Clean up
$inStream.Close()
$outStream.Close()

Write-Host "Copied $SourceHive → $DestHive"
