<#
Pack the extension into a zip suitable for Chrome Web Store.
Usage (PowerShell / Windows):
  pwsh ./build/pack-extension.ps1
#>
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$root = Resolve-Path (Join-Path $scriptDir "..")
$rootPath = $root.Path

Write-Host "Packaging extension from: $rootPath"

$zipPath = Join-Path $rootPath "sprpor-chatgpt-extension.zip"

# Exclude folders
$excludeFolders = @('.git', '.github', 'node_modules', 'build')

Write-Host "Collecting files (excluding: $($excludeFolders -join ', '))"
$files = Get-ChildItem -Path $rootPath -Recurse -File | Where-Object {
    $full = $_.FullName
    foreach ($e in $excludeFolders) {
        if ($full -like "*\$e\*") { return $false }
    }
    if ($_.Name -like '*.zip') { return $false }
    return $true
}

if (-not $files) {
    Write-Error "No files found to package. Are you running this from the repository containing the extension?"
    exit 1
}

# Create a temporary copy preserving relative paths so the zip has correct entries
$tmp = Join-Path $env:TEMP ([GUID]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tmp | Out-Null

foreach ($f in $files) {
    $rel = $f.FullName.Substring($rootPath.Length).TrimStart('\')
    $dest = Join-Path $tmp $rel
    $destDir = Split-Path $dest -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    Copy-Item -Path $f.FullName -Destination $dest -Force
}

Write-Host "Creating zip at: $zipPath"
try {
    Push-Location $tmp
    Compress-Archive -Path * -DestinationPath $zipPath -Force
    Pop-Location
    Write-Host "Package created: $zipPath"
} catch {
    Write-Error "Packaging failed: $_"
    Remove-Item -Recurse -Force $tmp
    exit 2
}

Remove-Item -Recurse -Force $tmp

Write-Host "Done. Verify the zip contains `manifest.json` and all expected assets.`n"