{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
    };
    shellAliases = {
      ll = "ls -lah";
      gst = "git status";
    };
    promptInit = ''
      PROMPT='%n@%m:%~%# '
    '';
  };

  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = lib.mkDefault pkgs.zsh;
}
