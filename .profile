# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# If running bash, include .bashrc if it exists. This will in-turn run tmux if
# the shell is interactive and tmux isn't already running. Tmux will in-turn
# start a new login shell, which sources .profile again.
if [ -n "${BASH_VERSION}" ] && [ -f "${HOME}/.bashrc" ]; then
	. "${HOME}/.bashrc"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
    PATH="${HOME}/bin:${PATH}"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.local/bin" ] ; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

# Initialize homebrew env vars
# # NOTE: Must come after sourcing .bashrc, or can get duplicate PATH entries from tmux
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Enable git completion on Mac (via brew install git bash-completion).
# NOTE: This depends on brew, which is why it's here and not in .bashrc.
# TODO: Use bash-completion@2 instead - need to figure out why that
# breaks vim completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Initialize fzf
# NOTE: This must come after bash completion script above
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#  Use ripgrep for fzf command (if installed)
if command -v "rg" &> /dev/null;  then
    export FZF_DEFAULT_COMMAND='rg --files --hidden'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

    _fzf_compgen_path() {
        rg --files --hidden "$1"
    }
fi

# Add pip install dir to path
export PATH="${HOME}/.local/bin:${PATH}"

# Add Go bins to path
export PATH="/usr/local/go/bin:${HOME}/go/bin:${PATH}"

# Initialize nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion

# Initialize cargo
[ -s "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"

# Other environment variables
export CDPATH="${CDPATH}:${HOME}/links"
export PGUSER="ncochran"
export MY_TLD=localhost
export DOCKER_BUILDKIT=1

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
