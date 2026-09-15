# Dotfiles

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Starship](https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white)

Personal macOS dotfiles managed with GNU Stow.

## Install (new machine)

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install git stow neovim tmux bat eza zoxide fzf starship fd ripgrep
brew install zsh-syntax-highlighting zsh-autosuggestions
brew install --cask iterm2 hammerspoon

# Clone and deploy
git clone https://github.com/latiif/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

# Reload shell
source ~/.zshrc

# Install neovim plugins (bootstraps lazy.nvim automatically)
nvim --headless "+Lazy! sync" +qa

# Install tmux plugin manager (TPM) and its plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

## Secrets

`.zshrc` sources `~/.zshrc.local` if it exists, and that file is **not** tracked
by this repo. Put machine-local secrets (API tokens, internal URLs, etc.) there:

```bash
cat > ~/.zshrc.local <<'EOF'
export SOME_TOKEN="..."
EOF
chmod 600 ~/.zshrc.local
```

## iTerm2 Setup

```bash
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
ln -sf ~/.config/iterm2/DynamicProfiles/profiles.json \
       ~/Library/Application\ Support/iTerm2/DynamicProfiles/
```

Then restart iTerm2.

## Files

- `.zshrc` - Shell configuration (secrets live in untracked `~/.zshrc.local`)
- `.config/nvim/` - Neovim configuration (lazy.nvim)
- `.tmux.conf` - tmux configuration (plugins via TPM, see Install)
- `.hammerspoon/init.lua` - Hammerspoon configuration
- `.config/starship.toml` - Prompt
- `.config/iterm2/` - iTerm2 profiles
