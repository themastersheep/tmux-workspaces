#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux bind p display-popup -b rounded -E "$CURRENT_DIR/scripts/workspaces.sh"
