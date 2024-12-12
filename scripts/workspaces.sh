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

    local bind_opts=$(tmux show-options -gqv @tmux_workspaces_fzf_bind_options)
    if [ -n "$bind_opts" ]; then
        # Parse the variable into separate --bind arguments with single quotes
        bind_args=$(echo "$bind_opts" | awk -F, '{for (i=1; i<=NF; i++) printf("--bind '\''%s'\'' ", $i)}')
    fi

    local fzf_opts=$(tmux show-option -gqv @tmux_workspaces_fzf_options)

    local session_id=$(echo -e "${workspaces}" | awk '!seen[$0]++' | eval "fzf $fzf_opts $bind_args")
    if [ -n "$session_id" ]; then
        if ! tmux has-session -t "$session_id" 2>/dev/null; then
            tmux new-session -d -s "$session_id" -c "$session_id"
        fi
        tmux switch-client -t "$session_id"

    else
        tmux display-message "something strange in your neighbourhood!"
    fi
}

tmux_workspaces
