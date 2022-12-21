#!/usr/bin/env bash
set -ex
mkdir -p ~/Downloads
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -o ~/Downloads/CascadiaCode.zip
mkdir fontfiles
cd fontfiles
unzip ~/Downloads/CascadiaCode.zip
rm *Windows*
mv *.otf ~/Library/Fonts/
cd ..
rm -rf fontfiles
rm ~/Downloads/CascadiaCode.zip
case $(uname) in
  'Darwin')
    xcode-select --install
    if brew --version; then
      echo "Homebrew is already installed"
    else
      echo "Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    brew tap wata727/tflint
    brew tap yleisradio/terraforms
    brew install \
      autoconf\
      aws-iam-authenticator\
      aws-sso-util\
      awscli\
      bash\
      ca-certificates\
      coreutils\
      curl\
      docker-completion\
      docker-credential-helper-ecr\
      exercism\
      fish\
      fswatch\
      gcc\
      gd\
      gettext\
      gh\
      git\
      glib\
      gmp\
      gnu-sed\
      gnupg\
      gnutls\
      grep\
      guile\
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
      nushell\
      openssh\
      pinentry\
      pinentry-mac\
      pipx\
      pkg-config\
      pre-commit\
      protobuf\
      pyenv\
      readline\
      shellcheck\
      smiller171/tap/kubecolor\
      ssh-copy-id\
      starship\
      telnet\
      terminal-notifier\
      terraform-docs\
      terrascan\
      tfenv\
      tflint\
      tfsec\
      theseal/ssh-askpass/ssh-askpass
      unbound\
      watch\
      wget\
      xclip\
      ykman\
      yq
    brew install --cask visual-studio-code
    pipx install aws-export-credentials
    mkcert -install
    login_user="$(logname)"
    chown -R "${login_user:=root}":staff ~/.config
    # One-time Bash profile setup for VSCode
    if [ ! -f ~/.bashSetup ]
    then
      touch ~/.bash_profile
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
      echo 'export PATH=~/.bin:~/.local/bin:$(brew --prefix)/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$(brew --prefix)/opt/grep/libexec/gnubin:${PATH}' >> ~/.bash_profile
    fi
    touch ~/.bashSetup

    ;;
  'Linux')
    apt-get update
    apt-get install -y\
      software-properties-common\
      build-essential\
      gnupg\
      scdaemon\
      python\
      python3\
      python-dev\
      python3-dev\
      python-pip\
      python3-pip\
      fish\
      jq\
      watch
    
    curl -sS https://starship.rs/install.sh | sh

    # curl -sSL https://get.docker.com | /bin/bash
    # curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # chmod +x /usr/local/bin/docker-compose
    ;;
esac

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
bash -c 'pyenv install 3.11.0' || true
bash -c 'pyenv install 2.7.18' || true
pyenv global 3.11.1 2.7.18 system || true


# Fish setup
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fish_plugins" ~/.config/fish/fish_plugins
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish > ~/.config/fish/completions/docker.fish
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish > ~/.config/fish/completions/docker-compose.fish

mkdir -p ~/.gnupg
chmod 0700 ~/.gnupg
ln -sf "$(pwd)/gpg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
chown -R "${LOGNAME}":"${LOGNAME}" ~/.config || chown -R "${LOGNAME}":"staff" ~/.config || true

git clone https://github.com/scopatz/nanorc.git ~/.nano
ln -sf ~/.nano/nanorc ~/.nanorc


mkdir -p ~/.git_template
ln -sf "$(pwd)/git/.gitconfig" ~/.gitconfig
ln -sf "$(pwd)/prompt/starship.toml" ~/.config/starship.toml
