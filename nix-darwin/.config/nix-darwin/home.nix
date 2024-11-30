{
  config,
  pkgs,
  ...
}:

{
  home.username = "administrator";
  home.homeDirectory = "/Users/administrator";
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.ripgrep
    pkgs.eza
    pkgs.fzf
    pkgs.zoxide
    pkgs.starship
    pkgs.fnm
    pkgs.yazi
    pkgs.typst
    pkgs.zathura
    pkgs.bacon
    pkgs.argc
    #pkgs.helm
    pkgs.htop
    pkgs.jq
    pkgs.just
    pkgs.kubectl
    pkgs.lazygit
    #pkgs.deno
  ];

  programs.home-manager.enable = true;

    #home.file = {
    #  ".config/nvim".source = ~/.dotfiles/nvim/.config/nvim;
    #  ".config/nix".source = ~/.dotfiles/nix/.config/nix;
    #  ".config/nix-darwin".source = ~/.dotfiles/nix-darwin/.config/nix-darwin;
    #  ".config/shell".source = ~/.dotfiles/shell/.config/shell;
    #  ".config/starship.toml".source = ~/.dotfiles/starship/.config/starship.toml;
    #  ".config/yazi".source = ~/.dotfiles/yazi/.config/yazi;
    #  ".config/zsh".source = ~/.dotfiles/zsh/.config/zsh;
    #  ".config/nushell".source = ~/.dotfiles/nushell/.config/nushell;
    #};

  programs.neovim = {
    enable = true;
  };

  #programs.zsh = {
  #  enable = true;
  #  initExtra = ''
  #    # Add any additional configurations here
  #    export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
  #    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  #      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  #    fi
  #  '';
  #};
}
