{
  description = "NixOS installer and configuration collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    local-keys.url = "path:./nixos/ssh_keys.nix.sample";
  };

  outputs = { self, nixpkgs, local-keys, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inputs = { inherit local-keys; };
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
