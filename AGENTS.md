# Repository Guidelines

## Project Structure & Module Organization
This repository is a small NixOS installer project. Key paths:
- `flake.nix` for flake inputs and outputs.
- `nixos/installer.nix` for the base installer configuration.
- `nixos/nix_version.nix` for the target Nix version selection.
- `nixos/neovim/` for Neovim-related configuration.
- `scripts/build-installer.sh` for the ISO build helper.
- `requirements/` for requirement documents.
If you add more configs, keep them under `nixos/` and name files after their role (e.g., `nixos/workstation.nix`).

## Build, Test, and Development Commands
- `nix build .#installerIso`  
  Builds the NixOS installer ISO. The `result` symlink points at the build output.
- `./scripts/build-installer.sh`  
  Convenience wrapper that builds the ISO and prints the output path.

## Coding Style & Naming Conventions
- 2-space indentation in Nix files.
- `snake_case` for file names and `kebab-case` for Nix attributes where appropriate.
- Module names should match their file paths (e.g., `nixos/installer.nix`).
If you add a formatter or linter, specify the tool and exact command here.

## Testing Guidelines
No tests are defined yet. When tests are added:
- Keep them in `tests/`.
- Use clear naming like `test_<feature>.nix` or `*_spec.sh`.
- Document separate unit and integration commands here.

## Commit & Pull Request Guidelines
There is no Git history yet, so no established commit convention exists. Suggested baseline:
- Use Conventional Commits style (e.g., `feat: add installer entrypoint`).
- Keep commits focused and include brief rationale in the body when needed.
For pull requests:
- Include a summary, testing notes, and any required config changes.
- Link related issues if applicable.
- Add screenshots only when UI changes are introduced.

## Security & Configuration Tips
If the installer handles secrets or machine-specific settings, keep them out of version control. Prefer `*.local` or `.env`-style files that are ignored by Git, and document required environment variables here.
