use std

export def editor [file?: path] {
    # to change default editor in most of commands replace nvim here
    nvim ($file | default .)
}

export def git_main_branch [] {
    let in_git_repo = (do { git rev-parse --abbrev-ref HEAD } | complete | get stdout | is-not-empty)

    if $in_git_repo == false {
        error make {msg: "not in git repo"}
    }

    let refs = (echo refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default} | str expand )
    for ref in $refs {
        let ref_exit_code = (do { git show-ref -q --verify $ref | complete | get exit_code })

        if $ref_exit_code == 0 {
            return ($ref | split words | last)
        }

    }
    return "master"
}

export def git_develop_branch [] {
    let in_git_repo = (do { git rev-parse --abbrev-ref HEAD } | complete | get stdout | is-not-empty)

    if $in_git_repo == false {
        error make {msg: "not in git repo"}
    }

    let refs = [dev, devel, development]
    for ref in $refs {
        let ref_exit_code = (do { git show-ref -q --verify $"refs/heads/($ref)" | complete | get exit_code })

        if $ref_exit_code == 0 {
            return ($ref | split words | last)
        }

    }
    return "develop"
}
alias core-ls = ls

def ls [
    dir?: path
    --long (-l)
    --all (-a)
] {
    let path = ($dir | default .)
    
    let result = if $all and $long {
        core-ls -la $path
    } else if $all {
        core-ls -a $path
    } else if $long {
        core-ls -l $path
    } else {
        core-ls $path
    }
    
    let colored = $result | each {|row|
        let colored_name = match $row.type {
            #"dir" => $"(ansi xblack;deepskyblue2;xpurplea;steelblue1b)($row.name)(ansi reset)"
            "dir" => $"(ansi steelblue1b)($row.name)(ansi reset)"
            "symlink" => $"(ansi cyan_bold)($row.name)(ansi reset)"
            "exe" => $"(ansi green_bold)($row.name)(ansi reset)"
            "file" => $"(ansi darkorange)($row.name)(ansi reset)"
            _ => $row.name
        }
        $row | update name $colored_name
    }
    
    if $long {
        $colored | reject modified | sort-by type
    } else {
        $colored | reject modified | sort-by type
    }
}

#def la [dir?: path] { ls -la ($dir | default .) | select name type mode user group size | sort-by type }
def glo [] { git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n 25 | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime} | sort-by date | select commit subject name date }
def glod [] { git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n 25 | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime} | sort-by date }

alias gcm = git checkout (git_main_branch)
alias gcd = git checkout (git_develop_branch)
alias ga = git add
alias gba = git branch -all
alias gcb = git checkout -b
alias gc = git commit --verbose
alias gcn! = git commit --verbose --no-edit --amend
alias gd = git diff 
alias gds = git diff --staged
alias glh = git pull origin (git rev-parse --abbrev-ref HEAD)
alias gph = git push origin HEAD
alias gfa = git fetch --all --prune
alias gst = git status

alias k = kubectl
alias e = editor
alias nuconf = editor $nu.config-path

def "nu-complete git branches" [] {
  git branch -a --sort=-creatordate --format '%(refname:short),%(subject)'
    | from csv --noheaders
    | rename value description
}

def "nu-complete git log" [] {
  git log -n 32 --pretty=%h»¦«%s
    | lines
    | split column "»¦«" value description
    | each {|x| $x | update value $"($x.value)"}
}

export def gco [branch: string@"nu-complete git branches"] {
    git checkout $branch
}

export def gbD [branch: string@"nu-complete git branches"] {
    git branch -D $branch
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

$env.config = (
    $env.config
        | upsert keybindings ($env.config.keybindings | append [(__edit_keybinding)])
)
