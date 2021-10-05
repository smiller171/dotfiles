#!/usr/bin/env bash
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$(pwd)/fish/fish_plugins" ~/.config/fish/fish_plugins
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
login_user="$(logname)"
chown -R "${login_user:=root}":staff ~/.config
