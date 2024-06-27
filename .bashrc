# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Start tmux if it exists and we're not already in tmux. Use homebrew
# version, if it exists (homebrew is not yet added to the $PATH here)
tmux_cmd="tmux"
if [ -x "/opt/homebrew/bin/tmux" ]; then
    tmux_cmd="/opt/homebrew/bin/tmux"
fi
if command -v "${tmux_cmd}" &> /dev/null \
    && [ -z "${TMUX}" ] \
    && [ "${TERM_PROGRAM}" != "vscode" ] \
    && [ -z "${VSCODE_CWD}" ]; then
    exec "${tmux_cmd}" new-session -A -s "${USER}"
fi
unset tmux_cmd


# On Mac, add GNU coreutils to PATH. Do this in .bashrc instead of .profile so
# it only takes effect for interactive shells (i.e. not for scripts, which
# might be Mac-specific). Must happen before dircolors script below.
if [ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]; then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi
if [ -d "/opt/homebrew/opt/grep/libexec/gnubin" ]; then
    export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
fi
if [ -d "/opt/homebrew/opt/gnu-sed/libexec/gnubin" ]; then
    export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
fi
if [ -d "/opt/homebrew/opt/findutils/libexec/gnubin" ]; then
    export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
fi
if [ -d "/opt/homebrew/opt/postgresql@16/bin" ]; then
    export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
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
case "${TERM}" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "${force_color_prompt}" ]; then
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
[ -s ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[ -s /opt/homebrew/opt/git/etc/bash_completion.d/git-prompt.sh ] && source /opt/homebrew/opt/git/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true # unstaged changes *, staged changed +
GIT_PS1_SHOWSTASHSTATE=true # stashed changes $
GIT_PS1_SHOWUNTRACKEDFILES=true # untracked files %
GIT_PS1_SHOWUPSTREAM="git auto" # behind origin <, ahead of origin >, diverged from origin <>, no difference = (could also use verbose & name options for more info)
GIT_PS1_DESCRIBE_STYLE="branch" # when detached head, shows commit relative to newer tag or branch (e.g. master~4)
GIT_PS1_HIDE_IF_PWD_IGNORED=true # do nothing if current directory ignored by git

PROMPT_DIRTRIM=3
if [ "${color_prompt}" = yes ]; then
    GIT_PS1_SHOWCOLORHINTS=true # dirty state and untracked file indicators are color-coded
    if [[ ${EUID} == 0 ]] ; then
        pre_prompt='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \w\[\033[00m\]'
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W$(__git_ps1 " (%s)")\n\$\[\033[00m\] '
    else
        pre_prompt='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]'
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w$(__git_ps1 " (%s)")\n\$\[\033[00m\] '
    fi
    post_prompt='\n\$\[\033[00m\] '
else
    pre_prompt='${debian_chroot:+($debian_chroot)}\u@\h \w'
    post_prompt='\n\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h \w$(__git_ps1 " (%s)")\n\$ '
fi
unset color_prompt force_color_prompt

error_code='\[\033[01;31m\]$(result=$?; if (( result != 0 )); then echo " ERROR: $result"; fi)\[\033[01;34m\]'
post_prompt="${error_code}${post_prompt}"

# If this is an xterm set the title to user@host:dir
case "${TERM}" in
xterm*|rxvt*|screen*)
    title='\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]'
    pre_prompt="${title}${pre_prompt}"
    ;;
*)
    ;;
esac

PROMPT_COMMAND="__git_ps1 '${pre_prompt}' '${post_prompt}'"
unset pre_prompt post_prompt error_code title

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ] || [ -x /opt/homebrew/opt/coreutils/libexec/gnubin/dircolors ]; then
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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_funcs ] && source ~/.bash_funcs

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

[ -f ~/.popsql_env ] && source ~/.popsql_env
