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


# Enable virtualfish
eval (python -m virtualfish)
