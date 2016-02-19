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
if [[ -r $HOME/.${HOSTNAME}-bashrc ]]; then
    source $HOME/.${HOSTNAME}-bashrc
fi

# vim:set foldenable foldmethod=marker filetype=sh tabstop=4 expandtab: