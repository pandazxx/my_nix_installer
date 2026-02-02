{
  description = "NixOS installer and configuration collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    installer-secrets = {
      url = "path:./nixos/installer_secrets.nix";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, installer-secrets, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            installerSecrets =
              if builtins.pathExists installer-secrets
              then import installer-secrets
              else throw "Missing installer secrets: override flake input installer-secrets with a valid file path.";
          };
          modules = [
            ./nixos/installer.nix
          ];
        };
      };

      packages.${system}.installerIso =
        self.nixosConfigurations.installer.config.system.build.isoImage;

      defaultPackage.${system} = self.packages.${system}.installerIso;
    };
}
