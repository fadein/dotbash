## because I can't spell...
alias gerp=grep
alias grpe=grep
alias hbu=hub
alias les=less
alias lss=less
alias mor=more
alias mroe=more
alias scd=cd
alias sl=ls
alias sls=ls
alias vm=mv
alias fiel=file
alias jorbs=jobs
alias jbos=jobs
alias jods=jobs

## lazy aliases
alias by=exit
alias bye=exit
alias cp='cp -i'
alias dirs='dirs -v'
alias ftp='ftp -i'
alias gdb='gdb -silent'
alias mv='mv -i'
alias pd=pushd
alias pwd='pwd -P'
alias rm='rm -i'
alias revert=/qa/other/ethan/Menu/RevertAndSnapshot.pl

## GNU options
if [[ -n "$HAVE_GNU_UTILS" ]]; then
    alias du='du -h'
    alias grep='grep -n --color=auto --mmap'
    alias l='ls -F --color=auto --time-style=locale'
    alias la='ls -a --color=auto --time-style=locale'
    alias ll='ls -lFh --color=auto --time-style=locale'
    alias lla='ls -alFh --color=auto --time-style=locale'
    alias lld='ls -lFhd --color=auto'
    alias llt='ls -lFht --color=auto'
    alias llS='ls -lFhS --color=auto --time-style=locale'
    alias ls='ls -F --color=auto --time-style=locale'
    alias lsd='ls -sF --color=auto --time-style=locale'
    alias lt='ls -Ft --color=auto --full-time'
    alias lta='ls -aFt --color=auto --full-time'
    alias lz='ls -lFhZ --color=auto'
    alias lZ='ls -lFhZ --color=auto'
    alias nl='nl -ba'
else
    alias grep='grep -n'
    alias l='ls -F'
    alias la='ls -a'
    alias ll='ls -lF'
    alias lla='ls -alF'
    alias lld='ls -lFd'
    alias llt='ls -lFdt'
    alias ls='ls -F'
    alias lsd='ls -dF'
    alias lt='ls -Ft'
    alias lta='ls -aFt'
fi

## vi commands:
alias :close="echo Cannot close last window"
alias :w="echo This isn\'t vim, sucka\!"
alias :wq='exit'
alias :q='exit'
alias :q!='exit'
alias :x='exit'
alias :r=cat
alias :e=vim
alias :split=vim

# vim:set foldenable foldmethod=marker filetype=sh tabstop=4 expandtab:
