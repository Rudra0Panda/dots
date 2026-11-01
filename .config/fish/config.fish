if status is-interactive
    # Commands to run in interactive sessions can go here
    set -e QT_STYLE_OVERRIDE
    set -gx QT_QPA_PLATFORMTHEME qt6ct
    set -gx QT_PLUGIN_PATH "/home/rudra/.local/lib/qt6/plugins:/home/rudra/.local/lib/qt/plugins:/usr/lib/qt6/plugins:/usr/lib/qt/plugins"
end


# Added by Antigravity CLI installer
set -gx PATH "/home/rudra/.local/bin" $PATH

# QODER_DISPATCHER_PATH v1
fish_add_path -p -m $HOME/.qoder/entry
# END QODER_DISPATCHER_PATH v1
