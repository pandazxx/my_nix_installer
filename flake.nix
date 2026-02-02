{
  description = "NixOS installer and configuration collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        installer = nixpkgs.lib.nixosSystem {
          inherit system;
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
