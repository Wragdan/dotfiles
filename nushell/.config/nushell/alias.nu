
#export def git_main_branch [] {
#    git remote show origin
#        | lines
#        | str trim
#        | find --regex 'HEAD .*?[：: ].+'
#        | first
#        | str replace --regex 'HEAD .*?[：: ]\s*(.+)' '$1'
#}

#export def git_main_branch [] {
#}

export def editor [file?: path] {
    # to change default editor in most of commands replace nvim here
    nvim ($file | default .)
}

alias e = editor
alias nuconf = editor $nu.config-path

#alias gcm = git checkout (git_main_branch)

let refs = (echo refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default} | str expand )

export def _git_log [v num] {
    let stat = if $v {
        _git_stat $num
    } else { {} }
    let r = (do -i {
        git log -n $num --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD
        | lines
        | split column "»¦«" sha message author email date
        | each {|x| ($x| upsert date ($x.date | into datetime))}
    })
    if $v {
        $r | merge $stat | reverse
    } else {
        $r | reverse
    }
}

def "nu-complete git branches" [] {
    git branch
    | lines
    | filter {|x| not ($x | str starts-with '*')}
    | each {|x| $"($x|str trim)"}
}

def "nu-complete git log" [] {
    git log -n 32 --pretty=%h»¦«%s
    | lines
    | split column "»¦«" value description
    | each {|x| $x | update value $"($x.value)"}
}

export def gl [
    commit?: string@"nu-complete git log"
    --verbose(-v)
    --num(-n):int=32
] {
    if ($commit|is-empty) {
        _git_log $verbose $num
    } else {
        git log --stat -p -n 1 $commit
    }
}

export def glv [
    commit?: string@"nu-complete git log"
    --num(-n):int=32
] {
    if ($commit|is-empty) {
        _git_log true $num
    } else {
        git log --stat -p -n 1 $commit
    }
}

export def gco [branch: string@"nu-complete git branches"] {
    git checkout $branch
}

export def gbD [branch: string@"nu-complete git branches"] {
    git branch -D $branch
}

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

export def gf [
    branch: string@"nu-complete git branches"
    remote?: string@"nu-complete git remotes"
] {
    let remote = if ($remote|is-empty) { 'origin' } else { $remote }
    git fetch $remote $branch
}

def __zoxide_menu [] {
    {
      name: zoxide_menu
      only_buffer_difference: true
      marker: "| "
      type: {
          layout: columnar
          page_size: 20
      }
      style: {
          text: green
          selected_text: green_reverse
          description_text: yellow
      }
      source: { |buffer, position|
          zoxide query -ls $buffer
          | parse -r '(?P<description>[0-9]+) (?P<value>.+)'
      }
    }
}

def __zoxide_keybinding [] {
    {
      name: zoxide_menu
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menu name: zoxide_menu }
      ]
    }
}

def __edit_keybinding [] {
    {
      name: edit
      modifier: control
      keycode: char_e
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: OpenEditor }
      ]
    }
}

$env.config  = ($env.config
              | upsert menus ($env.config.menus | append (__zoxide_menu))
              | upsert keybindings ($env.config.keybindings | append [(__zoxide_keybinding) (__edit_keybinding)])
              )
