#!/usr/bin/env bash
set -ex
case $(uname) in
  'Darwin')
    if brew --version; then
      echo "Homebrew is already installed"
    else
      echo "Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    brew tap wata727/tflint
    brew tap yleisradio/terraforms
    brew install act\
      ansible-lint\
      ansible\
      autoconf\
      aws-export-credentials\
      aws-iam-authenticator\
      aws-sso-util\
      awscli\
      azure-cli\
      bash\
      checkov\
      chtf\
      coreutils\
      dep\
      docker-credential-helper-ecr\
      eksctl\
      exercism\
      fish\
      fswatch\
      gdbm\
      gettext\
      gh\
      git\
      glab\
      gmp\
      gnu-sed\
      gnupg\
      gnupg\
      gnutls\
      grep\
      guile\
      helm\
      infracost\
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
      readline\
      sdm\
      shellcheck\
      ssh-copy-id\
      starship\
      telnet\
      terminal-notifier\
      terraform\
      terraform-docs\
      terrascan\
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

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
bash -c 'pyenv install 3.9.0' || true
bash -c 'pyenv install 3.8.6' || true
bash -c 'pyenv install 2.7.18' || true
pyenv global 3.9.0 3.8.6 2.7.18 system

pip3 install virtualenv virtualfish
pip2 install virtualenv virtualfish
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fish_plugins" ~/.config/fish/fish_plugins
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish > ~/.config/fish/completions/docker.fish
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish > ~/.config/fish/completions/docker-compose.fish
mkdir -p ~/.gnupg
chmod 0700 ~/.gnupg
ln -sf "$(pwd)/gpg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
chown -R "${LOGNAME}":"${LOGNAME}" ~/.config || chown -R "${LOGNAME}":"staff" ~/.config

git clone https://github.com/scopatz/nanorc.git ~/.nano
ln -sf ~/.nano/nanorc ~/.nanorc

git config --global core.editor nano
git config --global user.email scott@millergeek.xyz
git config --global user.name 'Scott Miller'
git config --global commit.gpgSign true
git config --global pull.rebase true
git config --global push.default current
git config --global tag.gpgSign true
