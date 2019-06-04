#!/usr/bin/env bash
apt-add-repository ppa:fish-shell/release-3
apt-get update
apt-get install -y fish
ln -sf "$(pwd)/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
chown -R "$(logname)":"$(logname)" ~/.config
