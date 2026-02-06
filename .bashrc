#!/bin/bash

PS1='\[\e[36m\](\@) \[\e[35m\][\h \W]\[\e[0m\]\$ '

export VISUAL=vim
export EDITOR=vim

umask 022

bind -m vi-insert "\C-l":clear-screen 2>>/dev/null
bind -m vi-command "\C-l":clear-screen 2>>/dev/null
bind -m vi-insert "\C-p": 2>>/dev/null

# disable empty tab auto-completion
shopt -s no_empty_cmd_completion

# I concede that 'bash-completion' isn't all bad, but force bash default
# completion for a number of file-based commands.
for command in ls less cat rm cp mv vim vimdiff view; do
    complete -o default -o bashdefault $command
done

# when shell exits, append to ~/.bash_history instead of overwriting
shopt -s histappend

alias ls="ls --color=auto"
alias vims="vim -S"
alias s="ls"            # fat fingers...
alias k="fc -s"         # repeat the last command
alias kl="kill -9 %+"   # kill the last ctrl+z'd process
alias tmux='tmux -u'    # force UTF-8 encoding in tmux

# Define some 'grep' exclusions for the local 'grep' override script.
export GREP_EXCLUDE_FILES=Session.vim,.*.sw?,changelog
export GREP_EXCLUDE_DIRS=.git,venv,__pycache__,.pytest_cache,.mypy_cache

export TZ=America/New_York

for file in $(ls ~/.bash.d/* 2>>/dev/null); do
    source $file
done

if [[ -d ~/.local/bin ]]; then
    export PATH="~/.local/bin:$PATH"
fi

# Deduplicate 'PATH' entries.
PATH="$(printf %s "$PATH" | awk -v RS=':' '!a[$0]++ { if (NR > 1) printf RS; printf $0 }')"
