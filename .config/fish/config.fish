if status is-interactive
    # Commands to run in interactive sessions can go here
    # CDPATH
    set -gx CDPATH $CDPATH . .. $HOME $HOME/Documents $HOME/Documents/code

    # Pyenv setup
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin

    # Golang setup
    set -Ux GOPATH $HOME/.local/go
    fish_add_path $GOPATH/bin

    # Yarn
    set -Ux YARN_ROOT $HOME/.yarn
    fish_add_path $YARN_ROOT/bin

    # Firefox wayland
    if test "$XDG_SESSION_TYPE" = "wayland"
        set -Ux MOZ_ENABLE_WAYLAND 1
    end


    # Set the default editor
    set -Ux EDITOR micro
    set -Ux VISUAL $EDITOR

    set -Ux FZF_CTRL_T_OPTS "--walker-skip .git,node_modules,target --preview 'eza --tree -L=3 {}'"

    # Aliases
    alias virtualenv="virtualenv --python $(which python)"
    alias diff="diff --color=auto"
    alias grep="grep -E"
    alias ll="exa -lh"
    alias ls="exa"
    alias la="exa -la"
    alias c="wl-copy -n"
    alias v="wl-paste"
    alias edit="micro"
    alias spt='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
    alias tree='exa --tree --level=3'
    alias pkglast="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 20"
    alias pkgorphan="pacman -Qqd | pacman -Rsu --print -"
    alias neofetch="fastfetch -c ~/.config/fastzen-browserfetch/config.jsonc"
    alias adb-shell="adb shell -t \"HOME='/sdcard' ENV='/sdcard/.adb/.mkshrc' sh -i\""


    # Load custom autocompletion
    source ~/.config/fish/completions/alembic.fish
    # Set up fzf key bindings
    fzf --fish | source
    pyenv init - | source
end
