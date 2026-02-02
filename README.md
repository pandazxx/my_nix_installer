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
Add your public key in `nixos/.ssh_authorized_keys`. One key per line as per `~/.ssh/authorized_keys` format. This file is ignored by git. Password auth is disabled by default.

## Configure software

### Neovim

Neovim related configuration lays under `nixos/neovim`.

### Zsh

Zsh bootstrap configuration lives under `nixos/zsh`.

### Tmux

Tmux bootstrap configuration lives under `nixos/tmux`.
