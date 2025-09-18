#!/usr/bin/env bash

function new_session() {

    local path=$1
    if [ -z "$path" ]; then
        tmux display-message "something strange in your neighbourhood!"
        return
    fi

    # tmux replaces "." with "_" when creating sessions
    # do the replacement ourselves to ensure we can switch
    # to the newly created session
    local session_id=${path//./_}

    if ! tmux has-session -t "$session_id" 2>/dev/null; then
        if [ ! -d "$path" ]; then
            tmux display-message "path not found: $path"
            return
        fi

        tmux new-session -d -s "$session_id" -c "$path"
    fi

    tmux switch-client -t "$session_id"
}

function tmux_workspaces() {

    local workspaces=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

    local find_in_path_options=$(tmux show-option -gqv @tmux_workspaces_find_in_path)
    local IFS
    if [ -n "$find_in_path_options" ]; then
        IFS=":" read -r -a opts <<< "$find_in_path_options"
        for opt in "${opts[@]}"; do
            IFS=, read -r dir pattern <<< "$opt"

            if [ -d "$dir" ]; then
                workspaces+="\n$(find "$dir" -maxdepth 1 -type d -name "${pattern:-*}" 2>/dev/null)"
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

    local fzf_command=("fzf")

    local fzf_opts=$(tmux show-option -gqv @tmux_workspaces_fzf_options)
    read -ra fzf_opts_array <<< "$fzf_opts"
    if [ ${#fzf_opts_array[@]} -gt 0 ]; then
        fzf_command+=("${fzf_opts_array[@]}")
    fi

    local bind_opts=$(tmux show-options -gqv @tmux_workspaces_fzf_bind_options)
    if [ -n "$bind_opts" ]; then
        fzf_command+=("--bind" "$bind_opts")
    fi

    local session_id=$(echo -e "${workspaces}" | awk '!seen[$0]++' | "${fzf_command[@]}")
    new_session "$session_id"
}


tmux_workspaces
