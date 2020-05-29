# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Behavior
shopt -s checkwinsize
shopt -s autocd
stty -ixon # Disable ctrl-s and ctrl-q.

# Base prompt
PS1_BASE="\[$(tput setaf 5)\][\[$(tput setaf 4)\]\u@\h\[$(tput setaf 6)\] \W\[$(tput setaf 5)\]]"

# Git completion and prompt
GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
GIT_BASE_PATH="${GIT_EXEC_PATH%/libexec/git-core}"

if test -d "$GIT_BASE_PATH/share/git/completion"; then
	GIT_COMPLETION_PATH="$GIT_BASE_PATH/share/git/completion"
elif test -d "$GIT_BASE_PATH/share/doc/git/contrib/completion"; then
	GIT_COMPLETION_PATH="$GIT_BASE_PATH/share/doc/git/contrib/completion"
fi

if test ! -z "$GIT_COMPLETION_PATH"; then
	source "$GIT_COMPLETION_PATH/git-completion.bash"
	source "$GIT_COMPLETION_PATH/git-prompt.sh"
	PS1_GIT='$(__git_ps1 " \[$(tput setaf 5)\](\[$(tput setaf 2)\]%s\[$(tput setaf 5)\])")'
fi

# Finish prompt
export PS1="$PS1_BASE""$PS1_GIT""\[$(tput setaf 5)\]\$ \[$(tput sgr0)\]"

# Aliases
alias grep='grep -r --color=auto'

alias ls='ls --color=auto --group-directories-first -hF'
alias l='ls -l'
alias ll='ls -Al'
alias la='ls -A'

alias :q="exit"
