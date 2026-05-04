#source ./env.nu
source ./alias.nu

$env.config = {
    show_banner: false,
    edit_mode: vi,
    buffer_editor: "nvim",
    #shell_integration: {
    #  osc2: false  # Disables path abbreviation and tab/window title updates
    #  osc7: false  # Disables directory communication with terminal
    #  osc8: false  # Disables clickable links in ls output
    #  osc133: false  # Disables prompt marking features
    #  osc633: false  # Disables VS Code integration features
    #  osc9_9: false  # Disables ConEmu integration
    #  reset_application_mode: false  # Disables SSH compatibility mode
    #},
    completions: {
      algorithm: "fuzzy" 
    }
    #menus: [],
    #keybindings: [
    #    {
    #        name: open_command_editor
    #        modifier: control
    #        keycode: char_e
    #        mode: [emacs, vi_normal, vi_insert]
    #        event: { send: openeditor }
    #    }
    #]
}


# configure autoload dir
mkdir ($nu.data-dir | path join vendor/autoload)

# zoxide
zoxide init nushell | save -f ($nu.data-dir | path join vendor/autoload/zoxide.nu)

# fnm
fnm env --json | from json | load-env
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.FNM_MULTISHELL_PATH)/bin")
$env.PATH = ($env.PATH | uniq)

# starship
mkdir ~/.cache/starship
starship init nu | save -f ($nu.data-dir | path join vendor/autoload/starship.nu)

# worktrunk
#wt config shell init nu | save -f ($nu.data-dir | path join vendor/autoload/wt.nu)

# carapace
#source $"($nu.cache-dir)/carapace.nu"
