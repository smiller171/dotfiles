#!/usr/bin/env bash
set -ex
mkdir -p ~/Downloads
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -o ~/Downloads/CascadiaCode.zip
mkdir -p fontfiles
cd fontfiles
unzip ~/Downloads/CascadiaCode.zip
rm ./*Windows* || echo 'No windows-specific font files'
mv ./*.ttf ~/Library/Fonts/
cd ..
rm -rf fontfiles
rm ~/Downloads/CascadiaCode.zip
mkdir -p ~/.config
mkdir -p ~/.ssh
case $(uname) in
  'Darwin')
    xcode-select --install || true
    if brew --version; then
      echo "Homebrew is already installed"
    else
      echo "Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew tap wata727/tflint
    brew tap yleisradio/terraforms
    brew tap jakehilborn/jakehilborn
    brew install \
      arc\
      argocd\
      autoconf\
      aws-iam-authenticator\
      aws-sso-util\
      awscli\
      bash\
      ca-certificates\
      coreutils\
      curl\
      displayplacer\
      docker-credential-helper-ecr\
      fish\
      fluxcd/tap/flux\
      fswatch\
      gawk\
      gcc\
      gd\
      gettext\
      gh\
      git\
      glab\
      glib\
      google-chrome\
      gping\
      gnu-sed\
      gnupg\
      gnutls\
      grep\
      hadolint\
      helm\
      iterm2\
      jq\
      k9s\
      keybase\
      kreuzwerker/taps/m1-terraform-provider-helper\
      kubectl\
      kubernetes-cli\
      kustomize\
      libffi\
      libfido2\
      libgcrypt\
      mkcert\
      nano\
      node\
      nushell\
      openssh\
      pinentry\
      pinentry-mac\
      pipx\
      pkg-config\
      pre-commit\
      pyenv\
      readline\
      shellcheck\
      shfmt\
      smiller171/tap/kubecolor\
      sops\
      ssh-copy-id\
      sshuttle\
      starship\
      telnet\
      terminal-notifier\
      terraform-docs\
      terrascan\
      tfenv\
      tflint\
      tfsec\
      thefuck\
      theseal/ssh-askpass/ssh-askpass\
      trunk-io\
      velero\
      watch\
      wget\
      xclip\
      ykman\
      yq
    brew install --cask\
      bettertouchtool\
      docker\
      keybase\
      obsidian\
      rocket\
      signal\
      unite\
      visual-studio-code
    pipx install aws-export-credentials
    curl -sSL https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg > /tmp/dockutil.pkg
    sudo installer -pkg /tmp/dockutil.pkg -target /
    ./dock-cleanup.fish || true
    ln -sf "$(pwd)/iterm2" ~/.config/iterm2
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "/Users/${LOGNAME}/.config/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    launchctl disable user/${UID}/com.openssh.ssh-agent

    mkcert -install
    login_user="$(logname)"
    chown -R "${login_user:=root}":staff ~/.config
    # One-time Bash profile setup for VSCode
    if [ ! -f ~/.bashSetup ]
    then
      touch ~/.bash_profile
      # shellcheck disable=SC2016
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
      # shellcheck disable=SC2016
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
bash -c 'pyenv install -y 3' || true
bash -c 'pyenv install -y 2' || true
pyenv global 3.11.1 2.7.18 system || true


# Fish setup
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fish_plugins" ~/.config/fish/fish_plugins
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish > ~/.config/fish/completions/docker.fish
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish > ~/.config/fish/completions/docker-compose.fish

chown -R "${LOGNAME}":"${LOGNAME}" ~/.config || chown -R "${LOGNAME}":"staff" ~/.config

sudo chsh -s $(which fish) ${LOGNAME}
sudo chsh -s $(which fish)

git clone https://github.com/scopatz/nanorc.git ~/.nano || true
ln -sf ~/.nano/nanorc ~/.nanorc


mkdir -p ~/.git_template
ln -sf "$(pwd)/git/.gitconfig" ~/.gitconfig
ln -sf "$(pwd)/git/global.gitignore" ~/.gitignore
ln -sf "$(pwd)/prompt/starship.toml" ~/.config/starship.toml

ln -sf "$(pwd)/homedir/.editorconfig" ~/.editorconfig
