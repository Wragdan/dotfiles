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
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/secrets" ] && source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/secrets

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/cargo/bin"
export PATH="$PATH:$HOME/.local/share/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

#vi mode
bindkey -v
export KEYTIMEOUT=1

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=($ZSH/plugins/zsh-autocompletions/src $fpath)

export GPG_TTY=$(tty)

#if [[ $(uname) == "Linux" ]]; then
#    #eval $(keychain --eval --quiet gitea-pc-gaming-01)
#    #. /opt/asdf-vm/asdf.sh
#fi

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# argc-completions
export ARGC_COMPLETIONS_ROOT="/Users/administrator/projects/argc-completions"
export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/macos:$ARGC_COMPLETIONS_ROOT/completions"
export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
# To add completions for only the specified command, modify next line e.g. argc_scripts=( cargo git )
argc_scripts=( $(/bin/ls -p -1 "$ARGC_COMPLETIONS_ROOT/completions/macos" "$ARGC_COMPLETIONS_ROOT/completions" | sed -n 's/\.sh$//p') )
source <(argc --argc-completions zsh $argc_scripts)

