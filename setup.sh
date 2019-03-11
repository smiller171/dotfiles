#!/usr/bin/env bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install python2 python3 nano gnupg pinentry-mac node
ln -sf $(pwd)/fish/fishfile ~/.config/fish/fishfile
ln -sf $(pwd)/fish/config.fish ~/.config/fish/config.fish
mkdir ~/.gnupg
ln -sf $(pwd)/gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
# Start or re-use a gpg-agent.
#
gpgconf --launch gpg-agent

# Ensure that GPG Agent is used as the SSH agent
set -e SSH_AUTH_SOCK
set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

git clone git@github.com:scopatz/nanorc.git ~/.nano
ln -sf ~/.nano/nanorc ~/.nanorc
