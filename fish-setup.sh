#!/usr/bin/env bash
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
login_user="$(logname)"
chown -R "${login_user:=root}":"${login_user:=root}" ~/.config
