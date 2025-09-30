use std "path add"

let os = (uname | get operating-system)

$env.EDITOR = "nvim"
$env.TERMINAL = "st"
if ($os == "Darwin") { $env.TERMINAL = "ghostty" }
$env.BROWSER = "librewolf"

$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"
$env.XINITRC = $"($env.XDG_CONFIG_HOME)/x11/xinitrc"
$env.ZDOTDIR = $"($env.XDG_CONFIG_HOME)/zsh"
$env.PASSWORD_STORE_DIR = $"($env.HOME)/.password-store"
$env.CARGO_HOME = $"($env.XDG_DATA_HOME)/cargo"
$env.GOPATH = $"($env.XDG_DATA_HOME)/go"
$env.GOMODCACHE = $"($env.XDG_CACHE_HOME)/go/mod"
$env.SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)"

path add $"($env.HOME)/.cargo/bin"
path add $"($env.HOME)/.local/share/cargo/bin"
path add $"($env.HOME)/.local/share/go/bin"
path add $"($env.HOME)/.local/bin"
path add $"($env.HOME)/go/bin"
path add "/opt/homebrew/bin"

if ($os == "Darwin") {
  brew shellenv csh 
    | lines 
    | parse --regex 'setenv (\w+) "?(.+)"?;' 
    | transpose -r 
    | into record 
    | load-env

  $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
  mkdir $"($nu.cache-dir)"
  carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
}
