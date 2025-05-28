export PATH=~/.scripts:$PATH
export PATH=$PATH:~/.cargo/bin # rustup places rust here, remove when not using rust
export PATH=$PATH:/usr/local/go/bin:/$HOME/go/bin
export PATH=$PATH:~/.protobuf/v25.1/bin

# Generated for k9s
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export TERMINAL=st
export EDITOR=vim
export VISUAL=vim
export BROWSER=google-chrome
export READER=zathura

xrdb ~/.Xresources

# No display set on WSL. This should be a hopefully sane way to set the display
[ -n "$WSL_DISTRO_NAME" ] && [ -n "$WSL_INTEROP" ] &&
	export DISPLAY=$(awk '/nameserver / {print $2}' /etc/resolv.conf):0 && # WSL 2
	export LIBGL_ALWAYS_INDIRECT=1
[ -n "$WSL_DISTRO_NAME" ] && [ -z "$WSL_INTEROP" ] &&
	export DISPLAY=localhost:0 # WSL 1

source ~/.bashrc
