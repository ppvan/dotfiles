if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx CDPATH $CDPATH . .. $HOME $HOME/Documents $HOME/Documents/code

    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
end

pyenv init - | source
