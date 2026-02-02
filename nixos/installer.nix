{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}: let
  sshKeysPath = inputs.local-keys;
  sshKeys =
    if builtins.pathExists sshKeysPath
    then import sshKeysPath
    else {
      username = "nixos";
      authorized_keys = [];
    };
  repoSrc = lib.cleanSourceWith {
    src = ../.;
    filter = path: type:
      let base = builtins.baseNameOf path;
      in base != ".git" && base != "result";
  };
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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
  services.getty.autologinUser = sshKeys.username;

  users.users.${sshKeys.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    openssh.authorizedKeys.keys = sshKeys.authorized_keys;
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
  isoImage.contents = [
    { source = repoSrc; target = "/opt/nixos_installer"; }
  ];

  system.stateVersion = "25.11";
}
