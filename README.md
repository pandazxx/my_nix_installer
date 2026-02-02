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
The installer reads SSH user and keys from a Nix file path provided at build time.

- Create a Nix file like:
  ```nix
  {
    username = "nixos";
    authorized_keys = [
      "ssh-ed25519 AAAA... user@host"
    ];
  }
  ```
- Build with:
  ```sh
  nix build .#packages.x86_64-linux.installerIso \
    --override-input installer-secrets path:/absolute/path/to/ssh_keys.nix
  ```
Password auth is disabled by default.

## Configure software

### Neovim

Neovim related configuration lays under `nixos/neovim`.

### Zsh

Zsh bootstrap configuration lives under `nixos/zsh`.

### Tmux

Tmux bootstrap configuration lives under `nixos/tmux`.

## Install From The ISO (UEFI Example)
The installer ISO does not format disks automatically. You must select the target disk and run these steps.

1. Boot the ISO and log in (autologin is enabled for the `nixos` user).
2. Identify disks:
   ```sh
   lsblk -f
   ```
3. Create partitions (example for `/dev/nvme0n1`):
   ```sh
   sudo parted /dev/nvme0n1 -- mklabel gpt
   sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
   sudo parted /dev/nvme0n1 -- set 1 esp on
   sudo parted /dev/nvme0n1 -- mkpart primary ext4 512MiB 100%
   ```
4. Format partitions:
   ```sh
   sudo mkfs.fat -F 32 /dev/nvme0n1p1
   sudo mkfs.ext4 /dev/nvme0n1p2
   ```
5. Mount:
   ```sh
   sudo mount /dev/nvme0n1p2 /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/nvme0n1p1 /mnt/boot
   ```
6. Generate config:
   ```sh
   sudo nixos-generate-config --root /mnt
   ```
7. Edit `/mnt/etc/nixos/configuration.nix` as needed, then install:
   ```sh
   sudo nixos-install
   ```
8. To install using this repo as a flake, run:
   ```sh
   sudo nixos-install --flake /opt/nixos_installer#installer
   ```
9. To fetch this flake from GitHub (example), you can clone it onto the installer and install directly:
   ```sh
   git clone https://github.com/example/nixos_installer.git /opt/nixos_installer
   sudo nixos-install --flake /opt/nixos_installer#installer
   ```
10. To install without cloning (example), point directly at the GitHub flake:
    ```sh
    sudo nixos-install --flake github:example/nixos_installer#installer
    ```
11. Reboot:
   ```sh
   sudo reboot
   ```

Notes:
- For BIOS systems, skip the EFI partition and adjust bootloader settings.
- For encryption, LVM, or Btrfs, partitioning and formatting steps differ.
