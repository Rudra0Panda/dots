#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# Added by Antigravity CLI installer
export PATH="/home/rudra/.local/bin:$PATH"

# Unset style override so qt6ct controls Qt themes
unset QT_STYLE_OVERRIDE
export QT_QPA_PLATFORMTHEME=qt6ct
