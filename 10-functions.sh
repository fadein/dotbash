# get the first version number from a text file
getVersion() {
    local VER=$(\grep -i version "$1" | head -n 1)
    VER=$(echo ${VER#*[Vv][Ee][Rr][Ss][Ii][Oo][Nn]*})
    VER=$(echo ${VER%%:*})
    echo $VER
}

# One interface to compare version numbers
#     Use < operator in modern Bashes >= 2
#     Do it the slow way otherwise
versionLessthan() {
    if [ "${BASH_VERSINFO[0]}" -le 2 ]; then
        #old, sucky way
        _versionLessthan() {
            local ver1=$1
            while [ $(echo $ver1 | egrep -c [^0123456789.]) -gt 0 ]; do
                char=$(echo $ver1 | sed 's/.*\([^0123456789.]\).*/\1/')
                char_dec=$(echo -n "$char" | od -b | head -1 | awk {'print $2'})
                ver1=$(echo $ver1 | sed "s/$char/.$char_dec/g")
            done
            local ver2=$2
            while [ `echo $ver2 | egrep -c [^0123456789.]` -gt 0 ]; do
                char=`echo $ver2 | sed 's/.*\([^0123456789.]\).*/\1/'`
                char_dec=`echo -n "$char" | od -b | head -1 | awk {'print $2'}`
                ver2=`echo $ver2 | sed "s/$char/.$char_dec/g"`
            done
            ver1=`echo $ver1 | sed 's/\.\./.0/g'`
            ver2=`echo $ver2 | sed 's/\.\./.0/g'`
            do_version_check "$ver1" "$ver2"
        }

        do_version_check() {
            [ "$1" == "$2" ] && return 1
            ver1front=`echo $1 | cut -d "." -f -1`
            ver1back=`echo $1 | cut -d "." -f 2-`
            ver2front=`echo $2 | cut -d "." -f -1`
            ver2back=`echo $2 | cut -d "." -f 2-`
            if [ "$ver1front" != "$1" ] || [ "$ver2front" != "$2" ]; then
                [ "$ver1front" -gt "$ver2front" ] && return 1
                [ "$ver1front" -lt "$ver2front" ] && return 0
                [ "$ver1front" == "$1" ] || [ -z "$ver1back" ] && ver1back=0
                [ "$ver2front" == "$2" ] || [ -z "$ver2back" ] && ver2back=0
                do_version_check "$ver1back" "$ver2back"
                return $?
            else
                [ "$1" -gt "$2" ] && return 1 || return 0
            fi
        }

        _versionLessthan "$1" "$2"
        return $?

    else
        #new, 1337 way
        if [[ $1 < $2 ]]; then
            return 0
        else
            return 1
        fi
    fi
}

# remove duplicate entries from a colon separated string while
# preserving order
# Example: Replace current PATH with the same thing, but without dups
# $ PATH=$(uniquify $PATH)
if versionLessthan $BASH_VERSION "2.05b"; then
    #The old version for Gimped Bash shells
    eval 'uniquify() {
    #use arg $2 as list separator, defaulting to :
    LIST_A=($(echo "$1" | (IFS=${2:-:}; while read WORD; do echo $WORD; done)))

    declare -a OUT_A
    for i in "${LIST_A[@]}"; do
        in=
        for j in "${OUT_A[@]}"; do
            if [[ "$i" = "$j" ]]; then
                in=1
                break
            fi
        done
        if [[ -z "$in" ]]; then
            OUT_A[${#OUT_A[@]}]=$i
        fi
    done

    local IFS=:
    echo "${OUT_A[*]}"
}'
else
    #An elegant implementation for a more civilized age.
    eval 'uniquify() {
    local IFS=${2:-:}  #use arg $2 as list separator, defaulting to :
    declare -a OUT_A LIST_A
    LIST_A=( $1 )

    for i in "${LIST_A[@]}"; do
        in=
        for j in "${OUT_A[@]}"; do
            if [[ "$i" = "$j" ]]; then
                in=1
                break
            fi
        done
        if [[ -z "$in" ]]; then
            OUT_A[${#OUT_A[@]}]=$i
        fi
    done

    echo "${OUT_A[*]}"
}'
fi

# this little gem lets me say .. .. .. to go back three directories
# Example:
# $ .. .. force rpt civil
..() {
    local SAVEOLDPWD="$PWD"

    #use the builtin cd instead of my function to avoid seeing .notes
    #files as we go
    builtin cd ..

    for d in "$@"
        do
            builtin cd "$d"
        done
    OLDPWD=$SAVEOLDPWD

    #now that we've arrived at our destination, display .notes
    notes
}

# this provides completion to my sweet .. command
_dotdotcomp() {
    local DST=.

    #build the dest string
    local i=0
    local IFS=$'\n'
    for ((i=1; $i < ${#COMP_WORDS[@]}-1; i+=1)); do
        DST="$DST/${COMP_WORDS[$i]}"
    done

    #TODO: bug with directories containing spaces b/c compgen
    # eval to counteract the possible backslashes in $DST
    COMPREPLY=( $(eval builtin cd ../$DST; compgen -o nospace -d ${COMP_WORDS[$COMP_CWORD]}) )

    return 0
}

# -o filenames tells complete to backslash escape certain chars in
# some directory/filenames
complete -o filenames -F _dotdotcomp ..

# if entering a directory with a special .notes file,
# echo its contents
cd() {
    if [[ -z "$1" ]]; then
        if builtin cd; then return; fi
    fi
    if ! builtin cd "$1"; then return; fi
    notes
}

# display directory notes
if fmt --version &>/dev/null; then
    #GNU coreutils fmt - is good with figlet output
    notes() {
        if [[ -r .notes && -z "$SHUSH" ]]; then
            fmt -s -w ${COLUMNS:-80} .notes
            echo
        fi
    }
else
    #Vanilla fmt - not good with figlet output :(
    notes() {
        if [[ -r .notes && -z "$SHUSH" ]]; then
            fmt -${COLUMNS:-80} .notes
            echo
        fi
    }
fi

# Re-run the previous command with root privileges; Hollywood-style
override() {
    local HISTTIMEFORMAT=
    PREVCMD=`history 2 | head -n1 | cut -c8-`
    eval sc $PREVCMD
}

# Swaps the contents of file1 with file2
swap() {
    if [ -z "$1" -o -z "$2" ]; then
        echo Usage: swap file1 file2
        echo Swaps the contents of file1 with file2
        return
    fi

    if [ ! -r $1 -a ! -w $1 ]; then
        echo No permission to move $1
        return
    fi
    if [ ! -r $2 -a ! -w $2 ]; then
        echo No permission to move $2
        return
    fi

    RANDFILENAME=${RANDOM}${$}

    mv -f $1 $RANDFILENAME
    mv -f $2 $1
    mv -f $RANDFILENAME $2
}

# Make and cd into new directory
mcdir() {
    if [ -n "$1" ]; then
        mkdir -p $1;
        cd $1;
    else
        echo "mcdir (pathname)"
    fi
}

# Echo the nth component of a colon-separated string.
# Ex. Go to the 3rd directory in $PERLLIB:
# cd $(nth 3 $PERLLIB)
nth() {
    if [ "$#" -lt 2 ]; then
        echo Too few arguments to nth: "$*";
        echo Usage: nth \<position\> \<list\> \<delimiter\>;
        return 65;
    fi;
    local PATHS=$2
    local DELIMIT=${3-":"};
    if [ "0" = `expr index $PATHS $DELIMIT` ]; then
        PATHS=$(eval echo \$$PATHS)
    fi
    echo $PATHS | cut -d$DELIMIT -f$1
}

# aliases using nth
    alias first='nth 1'
    alias second='nth 2'
    alias third='nth 3'
    alias fourth='nth 4'
    alias fifth='nth 5'
    alias sixth='nth 6'
    alias seventh='nth 7'
    alias eighth='nth 8'
    alias ninth='nth 9'
    alias tenth='nth 10'
    alias 1st='nth 1'
    alias 2nd='nth 2'
    alias 3rd='nth 3'
    alias 4th='nth 4'
    alias 5th='nth 5'
    alias 6th='nth 6'
    alias 7th='nth 7'
    alias 8th='nth 8'
    alias 9th='nth 9'
    alias 10th='nth 10'

#NOTE: the version of which (a csh script) on SunOS blows this up;
#it is brain-dead and always exits with return code 0 (and it doesn't
#redirect its error message to stderr)
if ! which watch &>/dev/null; then
    watch() {
        if [ "$#" -eq 0 ]; then
            echo "Usage:  watch [-n SEC] command"
            return 65
        fi

        local SEC=1 SCREENHEIGHT O OPTARG OPTIND

        while getopts ":n:" O
        do
            case "$O" in
                n)
                    if [ "$OPTARG" -ge 1 ]; then
                        SEC=$OPTARG
                    fi
                    ;;
            esac
        done
        shift $(($OPTIND - 1))

        local COMMANDMSG=
        if [ "$SEC" -gt 1 ]; then
            COMMANDMSG="every $SEC seconds: $@"
        else
            COMMANDMSG="every second: $@"
        fi

        echo $SEC/$COMMANDMSG
        let SCREENHEIGHT=$(( $LINES - 2))

        while true; do
            clear
            echo $COMMANDMSG
            eval $@ | head -n $SCREENHEIGHT
            sleep $SEC
        done
    }
fi

# vim:set foldenable foldmethod=indent filetype=sh tabstop=4 expandtab:
