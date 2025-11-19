#!/usr/bin/env bash
# Pack the extension into a zip suitable for Chrome Web Store.
# Usage (macOS / Linux):
#   sh ./build/pack-extension.sh

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
root_dir="$(cd "$script_dir/.." >/dev/null 2>&1 && pwd)"

echo "Packaging extension from: $root_dir"

out="$root_dir/sprpor-chatgpt-extension.zip"

cd "$root_dir"

# Exclude common VCS/build files and the build directory itself
zip -r "$out" . -x "*/.git/*" "*/.github/*" "node_modules/*" "build/*" "*.zip"

echo "Package created: $out"
echo "Done. Verify the zip contains manifest.json and all expected assets."
