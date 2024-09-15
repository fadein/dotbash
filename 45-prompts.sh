#set the PS1 prompt

# Set a control string put the hostname, TTY and CWD in the Titlebar
# of your Terminal Emulator's window
if  [[ ("${BASH_VERSINFO[0]}" -eq "2" )
    && ( "${BASH_VERSINFO[1]/[[:alpha:]]/}" -le "3") ]]; then
    #Bash version is le 2.03
    TTY=$(tty)
	TITLEBAR='\[\e]0;\h ${TTY##/dev/pts/} \W\007\]'
else
    #Bash version is gt 2.03
	TITLEBAR='\[\e]0;\h \l \W\007\]'
fi

#FOREGROUND COLORS   BACKGROUND COLORS   TERMINAL MODE MODIFIERS
#30m = black         40m = black         0 = normal
#31m = red           41m = red           1 = bold / bright
#32m = green         42m = green         4 = underline
#33m = yellow        43m = yellow        7 = reverse
#34m = blue          44m = blue
#35m = magenta       45m = magenta
#36m = cyan          46m = cyan
#37m = white         47m = white

# Color-code the hostname based on architecture:
case "$OSTYPE" in
    hpux*)
        # HP-UX = magenta
        HOSTCOLOR="\[\e[0;35m\]" ;;
    aix*)
        # AIX = cyan
        HOSTCOLOR="\[\e[0;36m\]" ;;
    solaris*)
        # Sun = yellow
        HOSTCOLOR="\[\e[0;33m\]" ;;
    linux*)
        # Linux = yellow on blue
        HOSTCOLOR="\[\e[0;33;44m\]" ;;
    cygwin*)
        # Cygwin = bright blue
        HOSTCOLOR="\[\e[1;34m\]" ;;
    *)
        # Unknown = black on blue
        HOSTCOLOR="\[\e[44;30m\]" ;;
esac

# Color-code the username; green if a regular user,
# red if root
case $UID in
    "0")
        USERCOLOR="\[\e[0;31m\]" ;;
    *)
        USERCOLOR="\[\e[1;32m\]" ;;
esac

#white text on dark background
#replace occurances of \e with \033 if this doesn't work
D_WHITE='\[\e[0;37m\]'
RESET='\[\e[0;0m\]'
V="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}.${BASH_VERSINFO[2]}"
PROMPT1="$D_WHITE${V} %\j ${USERCOLOR}\u${D_WHITE}@${HOSTCOLOR}\h${D_WHITE} \w\\\$$RESET "

case $TERM in
    *xterm*|rxvt)
        PS1="${TITLEBAR}${PROMPT1}" ;;
    *)
        PS1=${PROMPT1} ;;
esac


# cleanup the environment
unset TTY TITLEBAR D_WHITE RESET HOSTCOLOR USERCOLOR
