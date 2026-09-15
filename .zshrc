# ~/.zshrc: macOS configuration

# ================== ZSH Options ==================
setopt HIST_IGNORE_ALL_DUPS  # Don't save duplicate commands
setopt HIST_FIND_NO_DUPS     # Don't show duplicates in search
setopt HIST_SAVE_NO_DUPS     # Don't save duplicates
setopt SHARE_HISTORY         # Share history between sessions
setopt APPEND_HISTORY        # Append to history file
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY    # Add commands immediately
setopt AUTO_CD               # cd by just typing directory name
setopt AUTO_PUSHD            # Make cd push old dir onto stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates
setopt GLOB_COMPLETE         # Show completions for glob patterns

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=90000
SAVEHIST=90000

# ================== Environment Variables ==================
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="Catppuccin Mocha"

# Eza colors (di=directories, ln=symlinks, ex=executables)
# Format: attribute;color (1=bold, 96=bright cyan, 92=bright green)
export EZA_COLORS="di=1;96:ln=36:ex=1;92:*.tar=31:*.zip=31:*.jpg=35:*.png=35:*.mp4=34:*.mp3=35"

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
alias gr='groot'

# Vim to NVIM alias
alias vim='nvim'

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

# ================== Edit command in $EDITOR ==================
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ================== Completions ==================
# Load completions (with caching for speed)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Case-insensitive and partial-word completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Menu-style completion with arrow key navigation
zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab to go back

# Color completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Group completions by category
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Directory completion enhancements
zstyle ':completion:*' squeeze-slashes true           # Treat // as /
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' complete-options true          # Complete options for cd

# Show hidden files in completion
zstyle ':completion:*' file-patterns '%p:globbed-files' '*(-/):directories'

# Speed up completion by caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Better kill process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# SSH/SCP host completion
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*:scp:*' hosts off

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ================== Starship Prompt ==================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ================== Zoxide (smart cd) ==================
# Silence the "initialize at end of file" doctor warning: zsh-syntax-highlighting
# also needs to load near the end, so zoxide can't truly be last.
export _ZO_DOCTOR=0
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

# ================== Tmux Auto-start ==================
# Auto-start tmux: attach to existing session or create new one
# Skip if already in tmux or running inside Zed or VSCode
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "zed" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    # Only auto-start if we're in an interactive shell
    if [[ $- == *i* ]]; then
        # Try to attach to a detached session, otherwise create new
        tmux attach 2>/dev/null || tmux new-session
    fi
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
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Docker attach alias
a() {
    local container
    container=$(docker ps --format '{{.ID}}\t{{.Names}}' | fzf --height=40% --layout=reverse --border --prompt="Select container: ") || return 0
    local id=$(echo "$container" | awk '{print $1}')
    # Try bash first, fall back to sh if bash doesn't exist
    docker exec -it "$id" bash 2>/dev/null || docker exec -it "$id" sh
}
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

summarize() {
  claude -p "Summarize the following concisely:\n\n$(cat)"
}
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/latiif/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
