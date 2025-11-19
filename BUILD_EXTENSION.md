Build & Package - Superpower ChatGPT Extension
============================================

This file describes how to create a Chrome Web Store–ready zip of the extension.

Files added
- `build/pack-extension.ps1` — PowerShell script for Windows / PowerShell Core
- `build/pack-extension.sh` — POSIX shell script for macOS / Linux

Quick usage

Windows (PowerShell / PowerShell Core):

```powershell
# from the repo root
pwsh ./build/pack-extension.ps1
```

macOS / Linux:

```bash
# from the repo root
sh ./build/pack-extension.sh
# or make it executable then run
chmod +x ./build/pack-extension.sh
./build/pack-extension.sh
```

Output
- `sprpor-chatgpt-extension.zip` in the repository root. That zip is the artifact you can upload to the Chrome Web Store developer dashboard.

Notes & recommendations
- Verify `manifest.json` (name/version) is correct before uploading.
- Chrome Web Store may reject a `key` field in `manifest.json` for new uploads. If you encounter warnings when uploading, remove the `key` field from `manifest.json` and re-package.
- Make sure no secrets or private keys are embedded in files inside the repo before publishing.

If you'd like, I can:
- run the packaging script here (if you want me to attempt it), or
- remove the `key` from `manifest.json` and create a sanitized zip for upload.
