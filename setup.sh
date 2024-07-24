#!/usr/bin/env bash
set -ex

LOGNAME="$(logname)" || true
ID="$(id -un)" || ID="$(whoami)"
login_user="${LOGNAME:=${ID}}"

mkdir -p ~/Downloads
mkdir -p ~/.config
mkdir -p ~/.ssh
mkdir -p ~/.gnupg

# Fish setup
mkdir -p ~/.config/fish
ln -sf "$(pwd)/fish/fish_plugins" ~/.config/fish/fish_plugins
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
ln -sf "$(pwd)/awsconfig" ~/.aws/config
mkdir -p ~/.config/fish/completions
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish > ~/.config/fish/completions/docker.fish
curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish > ~/.config/fish/completions/docker-compose.fish

case $(uname) in
  'Darwin')
    curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -o ~/Downloads/CascadiaCode.zip
    mkdir -p fontfiles
    cd fontfiles
    unzip ~/Downloads/CascadiaCode.zip
    rm ./*Windows* || echo 'No windows-specific font files'
    mv ./*.ttf ~/Library/Fonts/
    cd ..
    rm -rf fontfiles
    rm ~/Downloads/CascadiaCode.zip

    xcode-select --install || true
    case $(uname -m) in
      'x86_64')
        eval "$(/usr/local/bin/brew shellenv)"
        ;;
      'arm64')
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
    esac

    if brew --version; then
      echo "Homebrew is already installed"
    else
      echo "Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      case $(uname -m) in
        'x86_64')
          eval "$(/usr/local/bin/brew shellenv)"
          ;;
        'arm64')   
          eval "$(/opt/homebrew/bin/brew shellenv)"
          ;;
      esac
    fi

    brew tap wata727/tflint
    brew tap yleisradio/terraforms
    brew tap jakehilborn/jakehilborn
    brew install google-chrome || true
    brew install \
      arc\
      argocd\
      autoconf\
      aws-iam-authenticator\
      aws-sso-util\
      aws-vault\
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
      gnu-sed\
      gnupg\
      gnutls\
      gping\
      grep\
      hadolint\
      helm\
      iterm2\
      jq\
      k9s\
      keybase\
      keymapp\
      kreuzwerker/taps/m1-terraform-provider-helper\
      kubectl\
      kubernetes-cli\
      kustomize\
      libffi\
      libfido2\
      libgcrypt\
      mas\
      mkcert\
      nano\
      node\
      nushell\
      openssh\
      pinentry-mac\
      pinentry\
      pipx\
      pkg-config\
      postman\
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
      yt-music\
      yq\
      yubico-authenticator
    brew install --cask\
      beeper\
      bettertouchtool\
      docker\
      keybase\
      obsidian\
      orbstack\
      rocket\
      signal\
      visual-studio-code\
      zed
    mas install 803453959 || true  # Slack
    pipx install aws-export-credentials || true

    # dockutil
    dockutil_version=$(curl -sSL \
             -H 'Accept: application/vnd.github+json' \
             -H 'X-GitHub-Api-Version: 2022-11-28' \
             https://api.github.com/repos/kcrawford/dockutil/releases/latest | jq -r '.tag_name')
    curl -sSL "https://github.com/kcrawford/dockutil/releases/download/${dockutil_version}/dockutil-${dockutil_version}.pkg" > /tmp/dockutil.pkg
    sudo installer -pkg /tmp/dockutil.pkg -target /
    ./dock-cleanup.fish || true

    ln -sf "$(pwd)/iterm2" ~/.config/iterm2
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "/Users/${login_user}/.config/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    launchctl disable user/${UID}/com.openssh.ssh-agent

    mkcert -install || true
    chown -R "${login_user:=root}":staff ~/.config
    # One-time Bash profile setup for VSCode
    if [ ! -f ~/.bashSetup ]
    then
      touch ~/.bash_profile
      # shellcheck disable=SC2016
      case $(uname -m) in
        'x86_64')
          echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.bash_profile
          ;;
        'arm64')   
          echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
          ;;
      esac
      # shellcheck disable=SC2016
      echo 'export PATH=~/.bin:~/.local/bin:$(brew --prefix)/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$(brew --prefix)/opt/grep/libexec/gnubin:${PATH}' >> ~/.bash_profile
    fi
    touch ~/.bashSetup

    ;;
  'Linux')
    sudo ln -sf /usr/bin/fish /usr/local/bin/fish || ln -sf /usr/bin/fish /usr/local/bin/fish
    sudo apt-get update || apt-get update
    PACKAGES=(
      software-properties-common\
      build-essential\
      gnupg\
      scdaemon\
      python3\
      python3-dev\
      python3-pip\
      fish\
      jq\
      watch
    )
    sudo apt-get install -y "${PACKAGES[@]}" || apt-get install -y "${PACKAGES[@]}"

    curl -sS https://starship.rs/install.sh | sh -s -- --yes

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

chown -R "${login_user}":"${login_user}" ~/.config || chown -R "${login_user}":"staff" ~/.config

sudo chsh -s "$(which fish)" "${login_user}"
sudo chsh -s "$(which fish)"

git clone https://github.com/scopatz/nanorc.git ~/.nano || true
ln -sf ~/.nano/nanorc ~/.nanorc


mkdir -p ~/.git_template
ln -sf "$(pwd)/git/.gitconfig" ~/.gitconfig
ln -sf "$(pwd)/git/global.gitignore" ~/.gitignore
ln -sf "$(pwd)/prompt/starship.toml" ~/.config/starship.toml

ln -sf "$(pwd)/homedir/.editorconfig" ~/.editorconfig


company=$(curl -Ls \
  -H 'Accept: application/vnd.github+json' \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  https://api.github.com/users/smiller171 | jq -r '.company')

case "${company}" in
  'Apothesource')
    source apothesource.sh
    ;;
esac
