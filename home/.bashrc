# .bashrc

# User specific aliases and functions

source ~/.git-prompt.sh

if [ -z "$PS1" ]; then
  return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi


# prompt
red="\033[1;31m"
norm="\033[0;39m"
yellow="\033[1;33m"
green="\033[0;32m"
function __exitcode() {
  local EXIT="$?"
  if [ $EXIT != 0 ]; then
    echo -e "${red}[Exit code $EXIT]${norm}"
  else
    echo -e "${green}[Exit code $EXIT]${norm}"
  fi
}
export PS1='$(__exitcode)\n\[\033[01;33m\]\u@\H\[\033[00m\]:\[\033[01;31m\]$(__git_ps1 "(%s) ")\w\[\033[00m\]\n\$ '

export EDITOR=vim
export LESS=' -R '
export HISTSIZE=130000
export SAVEHIST=130000
alias blah='f() { b=${1:-blah}; git branch $b master && git reset --hard HEAD^ && git checkout $b; }; f'
