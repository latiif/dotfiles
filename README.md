# Dotfiles

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Vim](https://img.shields.io/badge/Vim-019733?style=for-the-badge&logo=vim&logoColor=white)
![Starship](https://img.shields.io/badge/Starship-DD0B78?style=for-the-badge&logo=starship&logoColor=white)

Personal macOS dotfiles managed with GNU Stow.

## Install

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install git stow vim bat eza zoxide fzf starship fd ripgrep
brew install zsh-syntax-highlighting zsh-autosuggestions
brew install --cask iterm2 zed hammerspoon

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
- `.hammerspoon/init.lua` - Hammerspoon configuration
- `.config/starship.toml` - Prompt
- `.config/zed/settings.json` - Zed editor
- `.config/iterm2/` - iTerm2 profiles
