#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

nix build .#installerIso

out_path="$(readlink -f ./result)"

printf 'Built installer ISO at: %s\n' "$out_path"
