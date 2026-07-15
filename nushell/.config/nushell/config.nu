#source ./env.nu
source ./alias.nu

$env.config = {
    show_banner: false,
    edit_mode: vi,
    buffer_editor: "nvim",
    completions: {
      algorithm: "fuzzy" 
    }
}

let autoload_path = ($nu.data-dir | path join vendor/autoload)
let zoxide_path = ($autoload_path | path join zoxide.nu)
let starship_path = ($autoload_path | path join starship.nu)
let worktrunk_path = ($autoload_path | path join worktrunk.nu)
let carapace_path = ($autoload_path | path join carapace.nu)
let mise_path = ($autoload_path | path join mise.nu)

if not ($autoload_path | path exists) {
  mkdir $autoload_path
}

if ((which zoxide | is-not-empty) and (not ($zoxide_path | path exists))) {
  zoxide init nushell | save -f $zoxide_path
}

if ((which mise | is-not-empty) and (not ($mise_path | path exists))) {
  mise activate nu | save -f $mise_path
}

if ((which starship | is-not-empty) and (not ($starship_path | path exists))) {
  starship init nu | save -f $starship_path
}

if ((which wt | is-not-empty) and (not ($worktrunk_path | path exists))) {
  wt config shell init nu | save -f $worktrunk_path
}

if ((which carapace | is-not-empty) and (not ($carapace_path | path exists))) {
  carapace _carapace nushell | save -f $carapace_path
}

if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing --silent-if-unchanged}
        }
    )
}
