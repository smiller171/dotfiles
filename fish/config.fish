if status --is-interactive
    if not functions -q fisher
        set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
        curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
        fish -c fisher
    end
    if test "$__fisher_updated" != (date +%G%V) # Only update fisher once a week
        fisher update && set -U __fisher_updated (date +%G%V)
    end

    # Load .env file if it exists when using vscode terminal
    if test "$TERM_PROGRAM" = vscode && test -f ".env"
        dotenv .env && echo "✅ loaded .env"
    end

    # Start or re-use a gpg-agent.
    #
    set -x GPG_TTY (tty)
    gpgconf --launch gpg-agent

    # Ensure that GPG Agent is used as the SSH agent
    # set -e SSH_AUTH_SOCK
    # set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

    # Enable npx auto-fallback
    # source (npx --shell-auto-fallback fish | psub)

    # Add brew to path
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Set PATH
    fish_add_path -m \
        ~/.bin \
        ~/.local/bin \
        (brew --prefix)/bin \
        (brew --prefix openssh)/bin \
        (brew --prefix gawk)/libexec/gnubin \
        (brew --prefix coreutils)/libexec/gnubin \
        (brew --prefix grep)/libexec/gnubin \
        (brew --prefix gnu-sed)/libexec/gnubin \
        $HOME/.jenv/bin

    #Set SHELL
    set -x SHELL /usr/local/bin/fish
    set -gx EDITOR nano

    # Tell Terraform to use AWS Profile
    set -Ux AWS_SDK_LOAD_CONFIG 1

    # Set AWS SSO start url and region
    # set -gx AWS_DEFAULT_SSO_START_URL 'https://storable.awsapps.com/start#/'
    # set -gx AWS_DEFAULT_SSO_REGION us-east-1

    # Set up completion for aws-sso-util
    eval (env _AWS_SSO_UTIL_COMPLETE=source_fish aws-sso-util)

    #    function update_kube_context --on-variable AWS_PROFILE
    #        kubectl config use-context $AWS_PROFILE
    #    end

    # tabtab source for packages
    # uninstall by removing these lines
    [ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true


    # pyenv
    fish_add_path (pyenv root)/shims
    set -x PYENV_SHELL fish
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

    test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
    kubectl completion fish | source
    starship init fish | source

    set -x THEFUCK_OVERRIDDEN_ALIASES (alias | awk '{print $2}' | string join ',')
end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
