# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Load autocompletion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion 2> /dev/null
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc



# firefox wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi


# Load custom prompt.
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# Load alias
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi

# Set CDPATH
CDPATH=./:../:$HOME:$HOME/Documents:$HOME/Documents/code
CDPATH=$CDPATH:$HOME/Documents/code/

# GO to path
export GOPATH=$HOME/.local/go
export PATH="$GOPATH/bin:$PATH"

YARN_ROOT="$HOME/.yarn"
export PATH="$YARN_ROOT/bin:$PATH"

# Set the default editor
EDITOR=micro
VISUAL=$EDITOR
export EDITOR VISUAL
