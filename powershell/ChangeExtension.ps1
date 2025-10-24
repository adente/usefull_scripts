param (
    [Parameter(Mandatory = $false)]
    [string]$RootPath = (Get-Location).Path, # The root directory to start from

    [Parameter(Mandatory = $false)]
    [string]$OldExtension = "txt",           # Old extension (without dot)

    [Parameter(Mandatory = $false)]
    [string]$NewExtension = "log",           # New extension (without dot)

    [Parameter(Mandatory = $false)]
    [bool]$IncludeSubfolders = $true         # Include child folders by default
)

# Ensure extensions start with a dot
if ($OldExtension[0] -ne '.') { $OldExtension = ".$OldExtension" }
if ($NewExtension[0] -ne '.') { $NewExtension = ".$NewExtension" }

# Get files based on IncludeSubfolders
$files = if ($IncludeSubfolders) {
    Get-ChildItem -Path $RootPath -Recurse -File -Filter "*$OldExtension"
} else {
    Get-ChildItem -Path $RootPath -File -Filter "*$OldExtension"
}

foreach ($file in $files) {
    $newName = [System.IO.Path]::ChangeExtension($file.FullName, $NewExtension)
    Rename-Item -Path $file.FullName -NewName $newName
    Write-Host "Renamed: $($file.FullName) -> $newName"
}

# .\Change-Extension.ps1 -RootPath "C:\Test" -OldExtension "txt" -NewExtension "log" -IncludeSubfolders $false