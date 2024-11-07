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
        let ref_exit_code = (do { git show-ref -q --verify $ref | complete | get exit_code })

        if $ref_exit_code == 0 {
            return ($ref | split words | last)
        }

    }
    return "develop"
}

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

alias e = editor
alias nuconf = editor $nu.config-path
alias darw = darwin-rebuild switch --flake ~/.dotfiles/nix-darwin/.config/nix-darwin --show-trace
alias k = kubectl

export def "nu-complete kube ns" [] {
    kubectl get namespaces
    | from ssv -a
    | each {|x|
        {value: $x.NAME, description: $"($x.AGE)\t($x.STATUS)"}
    }
}

def "nu-complete kubectl get pods" [] { 
    ^kubectl get pods --output json | from json | get items | get metadata.name
}

def kgp [
    pod?: string@"nu-complete kubectl get pods"
    --namespace (-n): string@"nu-complete kube ns"
    --all (-a)
] {
    if ($pod | is-not-empty) {
        kubectl get pods -n $namespace $pod
    } else if $all {
        kubectl get pods -a --wide
    } else {
        kubectl get pods -n $namespace -wide $pod
    }
}

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
