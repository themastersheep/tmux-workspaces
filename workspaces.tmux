#!/usr/bin/env bash

setup() {
    local key=$(tmux show-option -gqv @tmux_workspaces_key_bind)
    local cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    tmux bind "${key:-p}" display-popup -b rounded -E "$cwd/scripts/workspaces.sh"
}

setup
