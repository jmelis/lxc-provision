# .bashrc

# Source global definitions

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

PS1='\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export PATH=$HOME/one-tools.git:$PATH

function git-recover() {
    file="$1"
    git checkout $(git rev-list -n 1 HEAD -- "$file")^ -- "$file"
}

function delkey {
    line=$1
    sed -i "${line}d" ~/.ssh/known_hosts
}

function gitroot {
    ROOTDIR=`git rev-parse --show-cdup 2>/dev/null`
    test -n "$ROOTDIR" && cd $ROOTDIR
}

function set_one_auth {
    if [ -n "$1" ]; then
        TMP=$(mktemp)
        echo "$1" > $TMP
        export ONE_AUTH=$TMP
    else
        unset ONE_AUTH
    fi
}

alias grep='grep --color=auto'
alias less='less -r'
alias tree='tree -CF'
alias mysql='mysql --sigint-ignore'
alias bare="grep -Ev '^\s*\t*($|#)'"
alias diff='colordiff -u'
alias vi='vim'
alias virsh='virsh -c qemu:///system'

# git aliases

alias git-graph='git log --oneline --graph --decorate'
alias gs='git status'
alias gl='git log'
alias gsl='git sl'
alias gr='gitroot'
alias grp='git pull --rebase && git push'

