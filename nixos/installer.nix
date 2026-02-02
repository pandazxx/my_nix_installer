{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: let
  authorizedKeysPath = ./.ssh_authorized_keys;
  authorizedKeys =
    if builtins.pathExists authorizedKeysPath
    then lib.filter (line: line != "") (lib.splitString "\n" (builtins.readFile authorizedKeysPath))
    else [];
in {
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./neovim
    ./tmux
    ./zsh
  ];

  networking.hostName = "nixos-installer";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "prohibit-password";
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    openssh.authorizedKeys.keys = authorizedKeys;
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    neovim
    tmux
    wget
    curl
    zsh
  ];

  nix.package = pkgs.nixVersions.latest;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Keep ISO output name stable for scripts.
  image.fileName = "nixos-installer.iso";

  system.stateVersion = "25.11";
}
