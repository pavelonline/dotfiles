{ config, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "man"
        "cp"
        "direnv"
        "emacs"
        "git"
        "gitignore"
        "git-prompt"
        "helm"
        "history"
        "man"
        "python"
        "pip"
        "pyenv"
        "rust"
        "rsync"

      ];
      theme = "trapd00r";
    };
  };
}
