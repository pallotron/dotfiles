# .bashrc

# User specific aliases and functions

if [ -z "$PS1" ]; then
  return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f ~/.bashrc_fb ]; then
  source ~/.bashrc_fb
fi

[[ -f ~/.config/pass.bash-completion ]] && source ~/.config/pass.bash-completion

if hostname | grep ^dev > /dev/null
then
  # ssh agent only if work env
  SSHPROFILE=~/.ssh_agent_state_${HOSTNAME}
  if [[ -z "${SSH_AGENT_PID}" ]] || ! (ps -p "${SSH_AGENT_PID}" -o user,comm | grep `getent passwd $(whoami) | cut -d: -f3` | grep -q " ssh-agent\ *$")
  then
    ssh-agent -s > "${SSHPROFILE}"
    .  "${SSHPROFILE}" > /dev/null
    ssh-add
  fi
fi

# prompt
red="\033[1;31m"
norm="\033[0;39m"
yellow="\033[1;33m"
green="\033[0;32m"

function __exitcode() {
  local EXIT="$?"
  local date=$(date +%H:%M:%S)
  if [ $EXIT != 0 ]; then
    echo -e "${red}[Exit code $EXIT @ ${date}]${norm}"
  else
    echo -e "${green}[Exit code $EXIT @ ${date}]${norm}"
  fi
}
[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh

# share history across ALL terminal in real time
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

export PS1='$(__exitcode)\n\[\033[01;33m\]\u@\H\[\033[00m\]:\[\033[01;31m\]$(__git_ps1 "(%s) ")\w\[\033[00m\]\n\$ '

export EDITOR=vim
export LESS=' -R '
export HISTSIZE=130000
export SAVEHIST=130000
alias blah='f() { b=${1:-blah}; git branch $b master && git reset --hard HEAD^ && git checkout $b; }; f'
