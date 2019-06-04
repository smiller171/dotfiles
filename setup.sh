#!/usr/bin/env bash
set -ex
case $(uname) in
  'Darwin')
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap wata727/tflint
    brew install python2 python3 nano gnupg pinentry-mac node terraform tflint mkcert jq exercism fish shellcheck
    mkcert -install
    ;;
  'Linux')
    apt-add-repository ppa:fish-shell/release-3
    apt-get update
    apt-get install -y build-essential python python3 python-dev python3-dev python-pip python3-pip gnupg fish
    snap install jq
    # curl -sSL https://get.docker.com | /bin/bash
    # curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # chmod +x /usr/local/bin/docker-compose
    ;;
esac

pip3 install virtualenv virtualfish thefuck awscli
pip install virtualenv virtualfish
ln -sf "$(pwd)/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish > ~/.config/fish/completions/docker.fish
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish > ~/.config/fish/completions/docker-compose.fish
mkdir -p ~/.gnupg
ln -sf "$(pwd)/gpg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
chown -R "$(logname)":"$(logname)" ~/.config

git clone git@github.com:scopatz/nanorc.git ~/.nano
ln -sf ~/.nano/nanorc ~/.nanorc
