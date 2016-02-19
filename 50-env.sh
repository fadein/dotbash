#set other important shell variables

# make a directory for Screen sessions if GNU Screen is installed
if which screen &>/dev/null; then
	export SCREENDIR=$HOME/.screens
    if [[ ! -d "$SCREENDIR" ]] && [[ -w "$HOME" ]]; then
        mkdir "$SCREENDIR"
    else
        unset SCREENDIR
    fi
fi

##work around missing commands
if which less &>/dev/null; then
    export PAGER=${PAGER:-less}
elif which more &>/dev/null; then
    export PAGER=${PAGER:-more}
    alias less=more
elif which pg &>/dev/null; then
    export PAGER=${PAGER:-pg}
    alias less=pg
    alias more=pg
else
    [[ -n "$PAGER" ]] && export PAGER
    alias less="echo could not find a pager on this system"
    alias more="echo could not find a pager on this system"
fi

if which vim &>/dev/null; then
    export EDIT=${EDIT:-vim}
elif which vi &>/dev/null; then
    export EDIT=${EDIT:-vi}
    alias vim=vi
else
    [[ -n "$EDIT" ]] && export EDIT
    alias vim="echo could not find Vim or vi on this system"
    alias vi="echo could not find Vim or vi on this system"
fi

export EDITOR=$EDIT
export TERM=${TERM:-xterm}
HISTFILE=~/.bash/history
HISTCONTROL=${HISTCONTROL:-ignoreboth}
HISTFILESIZE=${HISTFILESIZE:-1337}
HISTTIMEFORMAT=${HISTTIMEFORMAT:-%F %T }

if [[ -r ~/.bash/dircolors.sh ]]; then
    source ~/.bash/dircolors.sh
else
    if dircolors -b > ~/.bash/dircolors.sh; then
        source ~/.bash/dircolors.sh
    else
        echo Failed to create "~/.bash/dircolors.sh, trying to set dircolors with 'eval \$(dircolors -b)'"
        eval $(dircolors -b)
    fi
fi


#remove duplicate entries from $PATH, $LIBRARY_PATH, etc.
#if shell function uniquify() is defined

#TODO: uniquify isn't working as I remember it!
if declare -F uniquify >/dev/null; then
	:
##		[[ -n "$PATH" ]] && PATH=$(uniquify $PATH)
##  	[[ -n "$LIBRARY_PATH" ]] && LIBRARY_PATH=$(uniquify $LIBRARY_PATH)
##  	[[ -n "$LD_LIBRARY_PATH" ]] && LD_LIBRARY_PATH=$(uniquify $LD_LIBRARY_PATH)
##  	[[ -n "$LIBPATH" ]] && LIBPATH=$(uniquify $LIBPATH)
##  	[[ -n "$CPATH" ]] && CPATH=$(uniquify $CPATH)
##  	[[ -n "$MANPATH" ]] && MANPATH=$(uniquify $MANPATH)
fi
