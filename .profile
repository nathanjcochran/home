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

# Initialize homebrew env vars (must happen before .bashrc
# is called so the homebrew version of tmux is used)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

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
