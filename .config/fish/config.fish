if status is-interactive
    # Commands to run in interactive sessions can go here
    set -e QT_STYLE_OVERRIDE
    set -gx QT_QPA_PLATFORMTHEME qt6ct
    set -gx QT_PLUGIN_PATH "$HOME/.local/lib/qt6/plugins:$HOME/.local/lib/qt/plugins:/usr/lib/qt6/plugins:/usr/lib/qt/plugins"
end

set -gx PATH "$HOME/.local/bin" $PATH

# QODER_DISPATCHER_PATH v1
fish_add_path -p -m $HOME/.qoder/entry
# END QODER_DISPATCHER_PATH v1
