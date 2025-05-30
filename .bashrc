# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000

# Behavior
shopt -s checkwinsize
shopt -s autocd
shopt -s globstar
stty -ixon # Disable ctrl-s and ctrl-q.

# Git completion and prompt
GC_PATHS=( \
	'/usr/share/doc/git/contrib/completion' \
	'/usr/share/git-core/contrib/completion' \
	'C:/Program Files/Git/mingw64/share/git/completion' \
	)

for GCP in "${GC_PATHS[@]}"; do
	gcomp="${GCP}/git-completion.bash"
	gprompt="${GCP}/git-prompt.sh"
	if [ -f "${gcomp}" ] && [ -f "${gprompt}" ]; then
		[ "$OSTYPE" == "msys" ] || [ "$OSTYPE" == "cygwin" ] ||
			export GIT_PS1_SHOWDIRTYSTATE="true"
		source "$gcomp"
		source "$gprompt"
		PROMPT_COMMAND='PS1_GIT_TAG=$(__git_ps1 "%s")'
		break
	fi
done

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

alias glog='git log --graph --oneline --pretty=format:"%C(auto)%h %C(blue)%ad %C(auto)%d %s" --date=relative -n10'
alias glogs='git log --graph --oneline --pretty=format:"%C(auto)%h %C(blue)%ad %C(auto)%d %s" --date=relative'
alias gd='git diff'
alias gs='git status'

alias :q="exit"

## default launchers
[ -n "$(which vimx 2>/dev/null)" ] && alias vim='vimx --servername VIMX'
# alias jmux='tmux new -A -s Jmux julia' # this probably don't work that well with my new expanded tmux use.
alias jbare='julia --startup-file=no'
alias zathura='zathura --fork'
alias tmuxa='tmux attach'

planner501() {
	echo "python3 planner5.py ${*@Q}"
	ssh -T se-la-be-01 "cd electrictripplanner-web-devel/pylib; python3 planner5.py ${*@Q}"
}

be01() {
	echo "${*@Q}"
	ssh -T se-la-be-01 "cd electrictripplanner-web-devel/pylib; ${*@Q}"
}

deploy_morin_aws() {
    if [[ -n "$(git status --porcelain)" ]]; then
        echo "Git index is dirty, stash before deploying"
        return
    fi

    branchname="$(git rev-parse --abbrev-ref HEAD)"
    git checkout morinaws/deploy
    git pull
    git read-tree --reset -u ${branchname}
    git commit -m "Deploy ${branchname} to morin aws"
    git push
    git checkout ${branchname}
}

comp() {
    params=''
    ./plannerpod.sh -n prod -f -z $1 -- python3 planner5.py $2 $params
    ./plannerpod.sh -n morin -z $1 -- python3 planner5.py $2 $params
}

alias vpnon='sudo systemctl start gpd.service ; systemctl status gpd.service ; systemctl --user start gpa.service ; systemctl --user status gpa.service'
alias vpnoff='systemctl --user stop gpa.service ; systemctl --user status gpa.service ; sudo systemctl stop gpd.service ; systemctl status gpd.service'

## fuzzy commands
zd() {
	DEFAULT=( \
		"${HOME}/work" \
		"${HOME}/wrepos" \
		"${HOME}/repos" \
		"${HOME}/dotfiles" \
		"${HOME}/wdata" \
		"${HOME}/Downloads" \
		"${HOME}/windownload" \
		)
	dir=$(
		find -L ${1:-${DEFAULT[@]}} -type d -not -path *.git* 2> /dev/null |
		sed "s/${HOME//\//\\\/}/~/g" |
		fzf --preview='eval ls -ogA --color {}'
	)
	[ -n "${dir}" ] && eval cd "${dir}"
	}

# Launch tmux if it exists, not already in tmux, not logged in over ssh, and not
# using i3
if [ -n "$(which tmux 2>/dev/null)" ] && [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ "${XDG_SESSION_DESKTOP:0:2}" != "i3" ]; then
	# should do something more fance here to get easier session management
	tmux new -A -s main
fi
