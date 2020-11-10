#!/usr/bin/env bash
set -ex
case $(uname) in
  'Darwin')
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap wata727/tflint
    brew install act\
      ansible-lint\
      ansible\
      autoconf\
      aws-iam-authenticator\
      aws-okta\
      awscli\
      azure-cli\
      coreutils\
      dep\
      eksctl\
      exercism\
      fish\
      fswatch\
      gdbm\
      gettext\
      gh\
      git\
      gmp\
      gnu-sed\
      gnupg\
      gnupg\
      gnutils\
      grep\
      guile\
      helm-docs\
      helm\
      jq\
      kubernetes-cli\
      libffi\
      libfido2\
      libgcrypt\
      mkcert\
      nano\
      ncurses\
      node\
      nvm\
      openssh\
      openssl@1.1\
      pgpdump\
      pinentry-mac\
      pinentry\
      pkg-config\
      pre-commit\
      protobuf\
      pyenv\
      python\
      python2\
      python3\
      readline\
      reviewdog\
      shellcheck\
      ssh-copy-id\
      telnet\
      terminal-notifier\
      terraform-docs\
      terraform\
      tfenv\
      tflint\
      tfsec\
      thefuck\
      unbound\
      watch\
      wget\
      xclip\
      zlib
    mkcert -install
    ;;
  'Linux')
    apt-get update
    apt-get install -y software-properties-common build-essential gnupg scdaemon python python3 python-dev python3-dev python-pip python3-pip fish
    # curl -sSL https://get.docker.com | /bin/bash
    # curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # chmod +x /usr/local/bin/docker-compose
    ;;
esac

pip3 install virtualenv virtualfish
pip install virtualenv virtualfish
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish > ~/.config/fish/completions/docker.fish
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish > ~/.config/fish/completions/docker-compose.fish
mkdir -p ~/.gnupg
ln -sf "$(pwd)/gpg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
login_user="$(logname || echo root)"
chown -R "${login_user}":"${login_user}" ~/.config

git clone https://github.com/scopatz/nanorc.git ~/.nano
ln -sf ~/.nano/nanorc ~/.nanorc
