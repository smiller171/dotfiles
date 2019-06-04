#!/usr/bin/env bash
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
chown -R "$(logname)":"$(logname)" ~/.config
