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
export QT_PLUGIN_PATH="/home/rudra/.local/lib/qt6/plugins:/home/rudra/.local/lib/qt/plugins:/usr/lib/qt6/plugins:/usr/lib/qt/plugins"
