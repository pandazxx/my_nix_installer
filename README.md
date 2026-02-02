# README

A project to build a NixOS installer ISO and manage NixOS configurations. Default without GUI.

## Layout
- `flake.nix`: flake entry point and build outputs.
- `nixos/installer.nix`: base installer configuration.
- `nixos/tmux/`: Tmux bootstrap configuration.
- `nixos/zsh/`: Zsh bootstrap configuration.
- `scripts/build-installer.sh`: helper to build the ISO.

## Build the installer ISO
- `nix build .#installerIso`  
  Builds the ISO derivation. The resulting `result` symlink points to the build output; the ISO is typically under `result/iso/`.
- `./scripts/build-installer.sh`  
  Convenience wrapper around the same build and prints the output path.

## Configure SSH access
Copy `nixos/ssh_keys.nix.sample` to `nixos/.ssh_keys.nix`, then set the username and authorized keys. Password auth is disabled by default.

## Configure software

### Neovim

Neovim related configuration lays under `nixos/neovim`.

### Zsh

Zsh bootstrap configuration lives under `nixos/zsh`.

### Tmux

Tmux bootstrap configuration lives under `nixos/tmux`.
