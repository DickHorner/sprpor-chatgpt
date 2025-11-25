# Update local files with chatgpt.com domain and debug logging
$root = Split-Path -Parent $PSScriptRoot

Write-Host "Updating files in: $root"

# Read the updated manifest from GitHub workspace
$manifestJson = Get-Content "$PSScriptRoot\..\manifest.json" -Raw -Encoding UTF8
$manifestJson | Set-Content "$root\manifest.json" -Encoding UTF8 -NoNewline
Write-Host "✓ manifest.json updated"

# Update loadScript.js with debug logging
$loadScriptContent = @'
console.log('[Superpower ChatGPT] loadScript.js starting injection');
function injectScript(scriptUrl) {
  const newScriptElement = document.createElement('script');
  newScriptElement.setAttribute('src', scriptUrl);
  newScriptElement.setAttribute('type', 'text/javascript');

  newScriptElement.onload = function () {
    this.remove();
  };

  document.documentElement.prepend(newScriptElement);
}

const interceptorScriptUrl = chrome.runtime.getURL('scripts/interceptor/interceptor.js');
console.log('[Superpower ChatGPT] injecting interceptor', interceptorScriptUrl);
injectScript(interceptorScriptUrl);
console.log('[Superpower ChatGPT] loadScript.js finished');
'@

$loadScriptContent | Set-Content "$root\scripts\interceptor\loadScript.js" -Encoding UTF8 -NoNewline
Write-Host "✓ scripts\interceptor\loadScript.js updated"

# Create debugInject.js
$debugInjectContent = @'
// Debug injection helper
console.log('[Superpower ChatGPT] debugInject.js loaded on', window.location.origin, 'path:', window.location.pathname);
// Simple marker on document for visual confirmation
document.documentElement.setAttribute('data-superpower-chatgpt-debug', '1');
'@

$debugInjectContent | Set-Content "$root\scripts\content\debugInject.js" -Encoding UTF8 -NoNewline
Write-Host "✓ scripts\content\debugInject.js created"

Write-Host "`nAll files updated successfully!"
Write-Host "Run pack-extension.ps1 to create the zip."
