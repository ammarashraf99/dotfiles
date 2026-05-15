# Enable colors
autoload -U colors && colors

# Enable auto comletion
autoload -Uz compinit
compinit

# Enable vcs_info
autoload -Uz vcs_info
precmd() { vcs_info }

# Configure git info
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:*' enable git


# Simple prompt
setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f %F{yellow}${vcs_info_msg_0_}%f
%F{green}❯%f '


if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# export PATH=$PATH:/home/$(whoami)/.local/bin
export CPM_SOURCE_CACHE=$HOME/.cache/CPM
export EVEREST_TUTORIAL_DIR=~/everest-tutorial-module

# if [ -f ~/esp-idf/export.sh ]; then
#     . ~/esp-idf/export.sh &> /dev/null
# fi
