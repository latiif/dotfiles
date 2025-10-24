# ~/.bashrc: macOS configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

# Check window size after each command
shopt -s checkwinsize

# Enable globstar for recursive globbing
shopt -s globstar

# ================== Environment Variables ==================
export EDITOR="vim"
export VISUAL="vim"
export BAT_THEME="ansi"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Add user bin if it exists
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# ================== Aliases ==================
# Modern CLI replacements
if command -v eza &> /dev/null; then
    alias ls='eza --icons -1 -F --color=always --group-directories-first --long --no-permissions'
    alias ll='eza -la --icons --group-directories-first'
    alias la='eza -a --icons'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls -GF'
    alias ll='ls -lGFh'
    alias la='ls -aGF'
fi

if command -v bat &> /dev/null; then
    alias cat='bat'
fi

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'
alias groot='cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Utilities
alias python='python3'
alias pip='pip3'
alias h='history'
alias c='clear'
alias reload='source ~/.bashrc'

# macOS specific
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Clipboard - macOS uses pbcopy/pbpaste
alias pbcopy='pbcopy'
alias pbpaste='pbpaste'
alias y='pbcopy <'  # yank file to clipboard

# ================== Bash Completion ==================
# Homebrew bash completion
if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    . "$(brew --prefix)/etc/bash_completion"
fi

# Git completion
if [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
    . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
fi

# ================== Starship Prompt ==================
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# ================== Zoxide (smart cd) ==================
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
    alias cd='z'
fi

# ================== FZF Configuration ==================
if command -v fzf &> /dev/null; then
    eval "$(fzf --bash)"

    # FZF customization
    export FZF_DEFAULT_OPTS="
        --height=80%
        --layout=reverse
        --border
        --color=fg:#ebdbb2,bg:#282828,hl:#fabd2f
        --color=fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
        --color=info:#83a598,prompt:#bdae93,pointer:#fe8019
        --color=marker:#8ec07c,spinner:#fabd2f,header:#83a598
    "

    export FZF_CTRL_T_OPTS="
        --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {} 2>/dev/null || tree -C {} 2>/dev/null'
        --preview-window=right:60%
    "

    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

# ================== NVM (Node Version Manager) ==================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ================== Go Configuration ==================
if command -v go &> /dev/null; then
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOPATH/bin"
fi

# ================== Source local configuration ==================
# Load local bashrc if it exists (for machine-specific config)
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# Load bash aliases if they exist
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
