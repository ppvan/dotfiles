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
    alias edit="micro"
    alias neofetch="fastfetch -c ~/.config/fastfetch/config.jsonc"

    
    switch (uname)
        case Darwin
            # OSX (Mac)
            eval "/opt/bin/brew shellenv"
            alias c="pbcopy"
        case Linux
            # WSL 2
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            fish_add_path /mnt/c/WINDOWS/system32/clip.exe
            alias c="clip -n"
    end
end
