{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -lah";
      gst = "git status";
    };
    promptInit = ''
      PROMPT='%n@%m:%~%# '
    '';
  };

  environment.shells = [ pkgs.zsh ];
}
