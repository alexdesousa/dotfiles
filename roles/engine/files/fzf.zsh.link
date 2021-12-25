###############################################################################
# BEGIN: FZF

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

FD_OPTIONS="--follow"
export FZF_CTRL_T_COMMAND="fdfind $FD_OPTIONS"
export FZF_DEFAULT_OPTS="--no-mouse --reverse --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -30'"

# END: FZF
###############################################################################
