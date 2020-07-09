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
tput smkx # Make delete key work in bash in st

# Git completion and prompt
GIT_BASE_PATH="$(git --exec-path 2>/dev/null | sed 's/\/libexec\/git-core$//')"
GC_PATHS=( \
	"${GIT_BASE_PATH}"'/share/doc/git/contrib/completion' \
	"${GIT_BASE_PATH}"'/share/git/completion' \
	)

for GCP in "${GC_PATHS[@]}"; do [ -d "${GCP}" ] && GIT_COMPLETE="${GCP}"; done

if [ ! -z "$GIT_COMPLETE" ]; then
	[ "$OSTYPE" == "msys" ] || [ "$OSTYPE" == "cygwin" ] ||
		export GIT_PS1_SHOWDIRTYSTATE="true"
	source "$GIT_COMPLETE/git-completion.bash"
	source "$GIT_COMPLETE/git-prompt.sh"
	PROMPT_COMMAND='PS1_GIT_TAG=$(__git_ps1 "%s")'
fi

# Prompt
PS1_BASE="\[\e[35m\][\[\e[34m\]\u@\h\[\e[36m\] \W\[\e[35m\]]"
PS1_GIT='${PS1_GIT_TAG:+\[\e[35m\] (\[\e[32m\]$PS1_GIT_TAG\[\e[35m\])}'
PS1_END="\[\e[35m\]\$ \[\e[00m\]"
export PS1=${PS1_BASE}${PS1_GIT}${PS1_END}

# Aliases
alias grep='grep --color=auto'
alias rgrep='grep -r --color=auto'

alias ls='ls --color=auto --group-directories-first -hF'
alias l='ls -l'
alias ll='ls -Al'
alias la='ls -A'

alias glog='git log --graph --oneline -n30'
alias gd='git diff'
alias gs='git status'

[ -n "$(which vimx 2>/dev/null)" ] && alias vim='vimx'

alias jmux='tmux new -s Jmux julia'

alias :q="exit"
