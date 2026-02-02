#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

keys_path="${1:-}"
if [[ -n "$keys_path" ]]; then
  nix build .#packages.x86_64-linux.installerIso \
    --override-input installer-secrets "path:$keys_path"
else
  nix build .#packages.x86_64-linux.installerIso
fi

out_path="$(python3 -c 'import os; print(os.path.realpath("result"))')"

printf 'Built installer ISO at: %s\n' "$out_path"
