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

# Collect files while excluding common VCS and build artifacts
$files = Get-ChildItem -Path $rootPath -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\.git\\' -and
    $_.FullName -notmatch '\\.github\\' -and
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.FullName -notmatch '\\build\\' -and
    $_.Name -notlike '*.zip'
}

if (-not $files) {
    Write-Error "No files found to package. Are you running this from the repository containing the extension?"
    exit 1
}

$paths = $files | ForEach-Object { $_.FullName }

Write-Host "Creating zip at: $zipPath"

try {
    Compress-Archive -LiteralPath $paths -DestinationPath $zipPath -Force
    Write-Host "Package created: $zipPath"
} catch {
    Write-Error "Packaging failed: $_"
    exit 2
}

Write-Host "Done. Verify the zip contains `manifest.json` and all expected assets.`n"