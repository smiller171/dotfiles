if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -Ux pure_color_success (set_color green)
set -Ux pure_color_mute (set_color brcyan)
set -Ux pure_color_dark (set_color brgreen)

# Start or re-use a gpg-agent.
#
gpgconf --launch gpg-agent

# Ensure that GPG Agent is used as the SSH agent
set -e SSH_AUTH_SOCK
set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

# Enable npx auto-fallback
source (npx --shell-auto-fallback fish | psub)

thefuck --alias | source


# Set PATH
set -gx PATH ~/.bin (brew --prefix)/opt/grep/libexec/gnubin $PATH

# Tell Terraform to use AWS Profile
set -Ux AWS_SDK_LOAD_CONFIG 1

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true


# pyenv
set -gx PATH '/Users/smiller/.pyenv/shims' $PATH
set -gx PYENV_SHELL fish
source '/usr/local/Cellar/pyenv/1.2.20/libexec/../completions/pyenv.fish'
command pyenv rehash 2>/dev/null
function pyenv
    set command $argv[1]
    set -e argv[1]

    switch "$command"
        case rehash shell
                source (pyenv "sh-$command" $argv|psub)
        case '*'
                command pyenv "$command" $argv
    end
end
