#!/bin/bash

############################
# This script creates symlinks from the home directory to any desired dotfiles
# in ~/dotfiles
############################

########## Variables
dir=~/dotfiles
olddir=~/dotfiles_old
files=".bashrc .bash_profile .gitconfig .vimrc .vim .i3 .julia/config/startup.jl .Xresources"


# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles."
mkdir -p $olddir

# change to the dotfiles directory
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create
# symlinks
echo -e "\nCreating symlink to dotfiles, backing up any already existing files."
for file in $files; do
	mv ~/$file ~/dotfiles_old/
	echo -e "\tCreating symlink to $file in home directory."
	ln -s $dir/$file ~/$file
done

echo -e "\nDone, delete $olddir if everything is ok."
