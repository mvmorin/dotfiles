export PATH=$PATH:~/.scripts

export TERMINAL=st
export EDITOR=vim
export VISUAL=vim
export BROWSER=google-chrome
export READER=zathura

# No display set on WSL. This should be a hopefully sane way to set a resonable
# default.
[ -z "$DISPLAY" ] && export DISPLAY=localhost:0

source ~/.bashrc
