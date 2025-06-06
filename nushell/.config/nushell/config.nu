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

const local_path = "/Users/administrator"

# argc-completions
$env.ARGC_COMPLETIONS_ROOT = $"($local_path)/projects/argc-completions"
$env.ARGC_COMPLETIONS_PATH = ($env.ARGC_COMPLETIONS_ROOT + '/completions/macos:' + $env.ARGC_COMPLETIONS_ROOT + '/completions')
$env.PATH = ($env.PATH | prepend ($env.ARGC_COMPLETIONS_ROOT + '/bin'))
argc --argc-completions nushell | save -f $"($local_path)/projects/argc-completions/tmp/argc-completions.nu"
source $"($local_path)/projects/argc-completions/tmp/argc-completions.nu"

source ./alias.nu
