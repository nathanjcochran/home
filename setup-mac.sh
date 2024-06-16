#!/bin/bash

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies from Brewfile
brew bundle install

# Change default shell to bash
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells > /dev/null
chsh -s /opt/homebrew/bin/bash

# Install terminal profiles
open ~/.terminal_profiles/SolarizedDarkProfile.terminal
open ~/.terminal_profiles/SolarizedLightProfile.terminal
