export ZSH=$HOME/.config/zsh

### ---- history config -------------------------------------
export HISTFILE=~/.cache/zsh/history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=10000

# History won't save duplicates.
setopt HIST_IGNORE_ALL_DUPS

# History won't show duplicates on search.
setopt HIST_FIND_NO_DUPS

export EDITOR="nvim"

# Aliases
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc}" ] && source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc
source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc
source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/secrets
#source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/secrets
#source $ZSH/.aliasrc
#source $ZSH/.secrets

br() {
        result=$(git branch -a --color=always | grep -v '/HEAD\s' | sort |
                fzf --border --ansi --tac --preview-window right:70% \
                        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h
%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
                sed 's/^..//' | cut -d' ' -f1)
        if [[ $result != "" ]]; then
                if [[ $result == remotes/* ]]; then
                        git checkout --track $(echo $result | sed 's#remotes/##')
                else
                        git checkout "$result"
                fi
        fi
}

branchd() {
        result=$(git branch -a --color=always | grep -v '/HEAD\s' | sort |
                fzf --multi --border --ansi --tac --preview-window right:70% \
                        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h
%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
                sed 's/^..//' | cut -d' ' -f1)

        # for line in $result; do
        #         branch_arr+=("$line")
        # done
        if [[ $result != "" ]]; then
                if [[ $result == remotes/* ]]; then
                        exit 0
                else
                        git branch -D $(echo "$result"  | tr '\n' ' ')
                fi
        fi
}

export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/cargo/bin"
export PATH="$PATH:$HOME/.local/share/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"


export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

if [[ -x "$(command -v zellij)" ]];
then
    eval "$(zellij setup --generate-completion zsh | grep "^function")"
fi;

#vi mode
bindkey -v
export KEYTIMEOUT=1

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

proj() {
        result=$(find ~/projects -mindepth 1 -maxdepth 2 -type d | fzf)
        if [[ $result != "" ]]; then
                cd $result
        fi
}

# bun completions
[ -s "/Users/administrator/.bun/_bun" ] && source "/Users/administrator/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=($ZSH/plugins/zsh-autocompletions/src $fpath)

export GPG_TTY=$(tty)

if [[ $(uname) == "Linux" ]]; then
    #eval $(keychain --eval --quiet gitea-pc-gaming-01)
    #. /opt/asdf-vm/asdf.sh
fi
