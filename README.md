# Dotfiles

Personal macOS dotfiles managed with GNU Stow.

## Install

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install git stow vim bat eza zoxide fzf starship fd ripgrep
brew install zsh-syntax-highlighting zsh-autosuggestions
brew install --cask iterm2 zed

# Clone and deploy
git clone https://github.com/latiif/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

# Reload shell
source ~/.zshrc

# Install vim plugins
vim +PlugInstall +qall
```

## iTerm2 Setup

```bash
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
ln -sf ~/.config/iterm2/DynamicProfiles/profiles.json \
       ~/Library/Application\ Support/iTerm2/DynamicProfiles/
```

Then restart iTerm2.

## Files

- `.zshrc` - Shell configuration
- `.vimrc` - Vim configuration
- `.config/starship.toml` - Prompt
- `.config/zed/settings.json` - Zed editor
- `.config/iterm2/` - iTerm2 profiles
