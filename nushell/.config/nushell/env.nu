use std "path add"

#$nu.default-config-dir = $"($env.HOME)/.config"

let os = (uname | get operating-system)

#fpath[4,0]="/opt/homebrew/share/zsh/site-functions";
#PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Users/administrator/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/Users/administrator/.local/state/fnm_multishells/38172_1730521132487/bin:/etc/profiles/per-user/administrator/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/Users/administrator/.local/bin/:/Users/administrator/.local/bin//statusbar:/Users/administrator/.cargo/bin:/Users/administrator/.local/share/cargo/bin:/Users/administrator/.local/share/go/bin:/Users/administrator/.local/bin:/Users/administrator/go/bin"; export PATH;
#[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
#export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

if ($os == "Darwin") {
    $env.HOMEBREW_PREFIX = "/opt/homebrew"
    $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
    $env.HOMEBREW_REPOSITORY = "/opt/homebrew"
}

$env.EDITOR = "nvim"
$env.TERMINAL = "st"
$env.BROWSER = "firefox"

$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"
$env.XINITRC = $"($env.XDG_CONFIG_HOME)/x14/xinitrc"
$env.ZDOTDIR = $"($env.XDG_CONFIG_HOME)/zsh"
$env.PASSWORD_STORE_DIR = $"($env.HOME)/.password-store"
$env.CARGO_HOME = $"($env.XDG_DATA_HOME)/cargo"
$env.GOPATH = $"($env.XDG_DATA_HOME)/go"
$env.GOMODCACHE = $"($env.XDG_CACHE_HOME)/go/mod"
#$env.SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)"
$env.NIX_CONF_DIR = $"($env.HOME)/.config/nix"

path add $"($env.HOME)/.cargo/bin"
path add $"($env.HOME)/.local/share/cargo/bin"
path add $"($env.HOME)/.local/share/go/bin"
path add $"($env.HOME)/.local/bin"
path add $"($env.HOME)/go/bin"
path add $"($env.HOME)/.nix-profile/bin"

# darwin-nix
path add "/nix/var/nix/profiles/default/bin"
path add $"/etc/profiles/per-user/($env.USER)/bin"
path add "/run/current-system/sw/bin"
path add "/nix/var/nix/profiles/default/bin"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

