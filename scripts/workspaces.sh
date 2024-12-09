#!/usr/bin/env bash

function tmux_workspaces() {

    local workspaces=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

    local find_in_path_options=$(tmux show-option -gqv @tmux_workspaces_find_in_path)
    if [ -n "$find_in_path_options" ]; then
        IFS=":" read -r -a opts <<< "$find_in_path_options"
        for dir in "${opts[@]}"; do
            if [ -d "$dir" ]; then
                workspaces+="\n$(find "$dir" -maxdepth 1 -type d 2>/dev/null)"
            fi
        done
    fi

    local path_options=$(tmux show-option -gqv @tmux_workspaces_path)
    if [ -n "$path_options" ]; then
        IFS=":" read -r -a opts <<< "$path_options"
        for dir in "${opts[@]}"; do
            if [ -d "$dir" ]; then
                workspaces+="\n$dir"
            fi
        done
    fi

    SESSION_KEY=$(echo -e "${workspaces}" | awk '!seen[$0]++' | fzf)

    if [ -n "$SESSION_KEY" ]; then
        if ! tmux has-session -t "$SESSION_KEY" 2>/dev/null; then
            tmux new-session -d -s "$SESSION_KEY" -c "$SESSION_KEY"
        fi
        tmux switch-client -t "$SESSION_KEY"

    else
        tmux display-message "something strange in your neighbourhood!"
    fi
}

tmux_workspaces
