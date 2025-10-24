# ~/.zshrc: macOS configuration

# ================== ZSH Options ==================
setopt HIST_IGNORE_ALL_DUPS  # Don't save duplicate commands
setopt HIST_FIND_NO_DUPS     # Don't show duplicates in search
setopt HIST_SAVE_NO_DUPS     # Don't save duplicates
setopt SHARE_HISTORY         # Share history between sessions
setopt APPEND_HISTORY        # Append to history file
setopt INC_APPEND_HISTORY    # Add commands immediately
setopt AUTO_CD               # cd by just typing directory name
setopt AUTO_PUSHD            # Make cd push old dir onto stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates
setopt GLOB_COMPLETE         # Show completions for glob patterns

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000

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
alias reload='source ~/.zshrc'

# macOS specific
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Clipboard - macOS uses pbcopy/pbpaste
alias pbcopy='pbcopy'
alias pbpaste='pbpaste'
alias y='pbcopy <'  # yank file to clipboard

# ================== Completions ==================
# Load completions
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Menu-style completion
zstyle ':completion:*' menu select

# Color completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ================== Starship Prompt ==================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ================== Zoxide (smart cd) ==================
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# ================== FZF Configuration ==================
if command -v fzf &> /dev/null; then
    # Set up fzf key bindings and fuzzy completion
    source <(fzf --zsh)

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

    # Use fd for fzf if available (faster)
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
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

# ================== Syntax Highlighting (if installed) ==================
# Install with: brew install zsh-syntax-highlighting
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ================== Auto-suggestions (if installed) ==================
# Install with: brew install zsh-autosuggestions
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# ================== Source local configuration ==================
# Load local zshrc if it exists (for machine-specific config)
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# Load zsh aliases if they exist
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi
