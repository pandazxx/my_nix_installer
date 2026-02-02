{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
    escapeTime = 0;
    historyLimit = 10000;
    baseIndex = 1;
    keyMode = "vi";
    extraConfig = ''
      set -g mouse on
      set -g status-keys vi
      set -g mode-keys vi
      set -g pane-border-status top
      set -g pane-border-format " #{pane_index}: #{pane_current_command} "
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"
    '';
  };

  environment.systemPackages = [ pkgs.tmux ];
}
