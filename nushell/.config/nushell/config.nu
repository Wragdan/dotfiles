
alias ll = ls -l

source ~/.zoxide.nu
use ~/.cache/starship/init.nu

# fnm
fnm env --json | from json | load-env
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.FNM_MULTISHELL_PATH)/bin")
$env.PATH = ($env.PATH | uniq)

$env.config = {
    show_banner: false,
    edit_mode: vi,
    menus: [],
    keybindings: []
}

source ./alias.nu
