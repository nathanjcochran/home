# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Start tmux, if not already in tmux:
if [ -z "$TMUX" ]; then
    exec tmux new-session -A -s $USER
fi

# vi mode ftw
# set -o vi

# Preserve the physical directory structure when following symlinks
set -o physical

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=50000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# For git info in terminal prompt. See: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true # unstaged changes *, staged changed +
GIT_PS1_SHOWSTASHSTATE=true # stashed changes $
GIT_PS1_SHOWUNTRACKEDFILES=true # untracked files %
GIT_PS1_SHOWUPSTREAM="git auto" # behind origin <, ahead of origin >, diverged from origin <>, no difference = (could also use verbose & name options for more info)
GIT_PS1_DESCRIBE_STYLE="branch" # when detached head, shows commit relative to newer tag or branch (e.g. master~4)
GIT_PS1_HIDE_IF_PWD_IGNORED=true # do nothing if current directory ignored by git

PROMPT_DIRTRIM=3
if [ "$color_prompt" = yes ]; then
    GIT_PS1_SHOWCOLORHINTS=true # dirty state and untracked file indicators are color-coded
    if [[ ${EUID} == 0 ]] ; then
        PRE_PROMPT_COMMAND='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \w\[\033[00m\]'
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W$(__git_ps1 " (%s)")\n\$\[\033[00m\] '
    else
        PRE_PROMPT_COMMAND='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]'
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w$(__git_ps1 " (%s)")\n\$\[\033[00m\] '
    fi
    POST_PROMPT_COMMAND='\n\$\[\033[00m\] '
else
    PRE_PROMPT_COMMAND='${debian_chroot:+($debian_chroot)}\u@\h \w'
    POST_PROMPT_COMMAND='\n\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h \w$(__git_ps1 " (%s)")\n\$ '
fi
unset color_prompt force_color_prompt

ERROR_CODE_COMMAND='\[\033[01;31m\]$(RESULT=$?; if (( RESULT != 0 )); then echo " ERROR: $RESULT"; fi)\[\033[01;34m\]'
POST_PROMPT_COMMAND="$ERROR_CODE_COMMAND$POST_PROMPT_COMMAND"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen*)
    TITLE_COMMAND='\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]'
    PRE_PROMPT_COMMAND="$TITLE_COMMAND$PRE_PROMPT_COMMAND"
    ;;
*)
    ;;
esac

PROMPT_COMMAND="__git_ps1 '$PRE_PROMPT_COMMAND' '$POST_PROMPT_COMMAND'"
unset PRE_PROMPT_COMMAND POST_PROMPT_COMMAND

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='LC_COLLATE=C ls -AlhXF --g'
alias la='LC_COLLATE=C ls -A'
alias l='LC_COLLATE=C ls -CF'
alias l1='LC_COLLATE=C ls -1XF --g'

# other aliases
alias j='jobs'
alias kj='kill $(jobs -p)'
alias postman='postman &> /dev/null'
alias dc='docker-compose'
alias grepr='grep -Rn --exclude-dir=".git" --exclude-dir="vendor" --exclude-dir="node_modules"'
alias grepgo='grep -Rn --exclude-dir=".git" --exclude-dir="vendor"'
alias grepjs='grep -Rn --exclude-dir=".git" --exclude-dir="node_modules" --exclude-dir="build" --exclude-dir="cache" --exclude="*-lock.*"'
alias todo='grepr TODO'
alias todiff='git diff dev -S "TODO:" --name-only'
alias treer='tree -a -I vendor'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_funcs ]; then
    . ~/.bash_funcs
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add pip install dir to path
export PATH="$HOME/.local/bin:$PATH"

# set up go env variables:
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

export CDPATH="$CDPATH:$HOME/links"

export PGUSER="ncochran"

export MY_TLD=localhost

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source "$HOME/.cargo/env"
