if [ "${USER}" = "root" ] ; then
  export PS1="\[\e[31m\]\u\[\e[m\]|\[\e[36m\]\w\[\e[m\]> "
else
  export PS1="\[\e[34m\]\u\[\e[m\]|\[\e[36m\]\w\[\e[m\]> "
fi
alias about="neofetch"
alias ls="ls --color"
export HISTSIZE=50
export HISTCONTROL=ignoreboth
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
