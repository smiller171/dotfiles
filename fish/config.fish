if status --is-interactive
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
    set -x GPG_TTY (tty)
    gpgconf --launch gpg-agent

    # Ensure that GPG Agent is used as the SSH agent
    # set -e SSH_AUTH_SOCK
    # set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

    # Enable npx auto-fallback
    # source (npx --shell-auto-fallback fish | psub)

    thefuck --alias | source


    # Set PATH
    set -gx PATH ~/.bin ~/.local/bin (brew --prefix)/opt/grep/libexec/gnubin $PATH

    #Set SHELL
    set -gx SHELL /usr/local/bin/fish
    
    set -gx EDITOR nano

    # Tell Terraform to use AWS Profile
    set -Ux AWS_SDK_LOAD_CONFIG 1

    # Set AWS SSO start url and region
    set -gx AWS_DEFAULT_SSO_START_URL 'https://storable.awsapps.com/start#/'
    set -gx AWS_DEFAULT_SSO_REGION us-east-1

    # Set up completion for aws-sso-util
    eval (env _AWS_SSO_UTIL_COMPLETE=source_fish aws-sso-util)

    # tabtab source for packages
    # uninstall by removing these lines
    [ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true


    # pyenv
    set -gx PATH '/Users/smiller/.pyenv/shims' $PATH
    set -gx PYENV_SHELL fish
    pyenv init - | source
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
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
# ~/.config/fish/config.fish

starship init fish | source
