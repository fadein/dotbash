# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# Source global definitions
[[ -f /etc/bashrc ]] && source /etc/bashrc

# Source my modularized dotfiles
for F in ~/.bash/[0-9][0-9]-*.sh; do
    source $F
done

# run site-specific stuff in .site-bashrc
[[ -r $HOME/.${HOSTNAME}-bashrc ]] && source $HOME/.${HOSTNAME}-bashrc

# Disable flow control so that Ctrl-S doesn't lock up the terminal
stty -ixon

# Launch the SSH agent using my customizations
# This line works if the directory containing this script is in $PATH
source ssh-agent-startup.sh

# vim:set foldenable foldmethod=marker filetype=sh tabstop=4 expandtab:
