if status is-interactive
    # Commands to run in interactive sessions can go here
    # CDPATH
    set -gx CDPATH $CDPATH . .. $HOME $HOME/Documents $HOME/Documents/code

    # Set the default editor
    set -Ux EDITOR micro
    set -Ux VISUAL $EDITOR

    # Aliases
    alias virtualenv="virtualenv --python $(which python)"
    alias diff="diff --color=auto"
    alias grep="grep -E"
    alias ll="eza -lh"
    alias ls="eza"
    alias la="eza -la"
    alias tree='eza --tree --level=3'
    alias c="wl-copy -n"
    alias v="wl-paste"
    alias edit="micro"
    alias neofetch="fastfetch -c ~/.config/fastfetch/config.jsonc"

    switch (uname)
        case Darwin
            eval "/opt/bin/brew shellenv"
        case Linux
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    end
end
