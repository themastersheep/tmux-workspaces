# tmux-workspaces

A simple `tmux` plugin for efficiently managing and switching between workspaces. The plugin leverages the `fzf` fuzzy finder for an intuitive selection interface and integrates custom configurations for workspace discovery.

#### Features
* List Current Sessions: Displays active `tmux` sessions for quick switching.
* Dynamic Workspace Discovery: Searches specified directories for workspace paths.
* Flexible Configuration: Customize search paths via `tmux` options.
* Interactive Interface: Uses `fzf` for workspace selection.
* Automatic Session Creation: Creates a new `tmux` session for selected paths if one doesn't already exist.

#### Key Bindings

* Default Key Binding: prefix + p
  * Opens the workspaces interface in a tmux popup.

#### Dependencies
Before using the plugin, ensure the following dependencies are installed:

* `tmux` (>= 2.1): Terminal multiplexer.
* `fzf`: Command-line fuzzy finder.
* `bash`: Required to run the script.
* `awk`: Required to parse @tmux_workspaces_bind_options
* Optional: Directory paths configured in @tmux_workspaces_find_in_path or @tmux_workspaces_path.


#### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Please make sure you have
[tmux-workspaces](https://github.com/themastersheep/tmux-workspaces) installed.

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'themastersheep/tmux-workspaces'

Hit `prefix + I` to fetch the plugin and source it. The plugin will
automatically start "working" in the background, no action required.

#### Manual Installation

Please make sure you have
[tmux-workspaces](https://github.com/themastersheep/tmux-workspaces) installed.

Clone the repo:

    $ git clone https://github.com/themastersheep/tmux-workspaces ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/workspaces.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`

The plugin will automatically start "working" in the background, no action
required.


#### Configuration

The plugin supports the following configuration options:

* `@tmux_workspaces_find_in_path`
  * A colon-separated list of directories to recursively search for workspaces.

Example:

    set -g @tmux_workspaces_find_in_path "/home/user/projects:/var/www"

* `@tmux_workspaces_path`
  * A colon-separated list of directories to include as workspaces without recursion.

Example:

    set -g @tmux_workspaces_path "/home/user/docs:/home/user/tmp"

* `@tmux_workspaces_fzf_options`
  * Configure `fzf` options

Example:

    set -g @tmux_workspaces_fzf_options "--reverse"

* `@tmux_workspaces_fzf_bind_options`
  * Configure `fzf` bind arguments
  * This supports a comma delimited list of values, format: key:action

Example:

    set -g @tmux_workspaces_fzf_bind_options "ctrl-j:jump-accept,ctrl-x:become(nvim {})"

#### License
[MIT](LICENSE)
