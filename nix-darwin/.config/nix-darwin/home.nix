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
  ];

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
