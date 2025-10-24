# Dotfiles - macOS Configuration

Personal dotfiles for macOS, managed with GNU Stow.

## Features

- **Zsh**: Enhanced shell configuration with modern CLI tools (macOS default)
- **Vim**: Comprehensive vim configuration with plugins
- **Starship**: Beautiful, minimal prompt
- **Zed**: Modern code editor configuration
- **iTerm2**: Terminal emulator profiles and settings

## Prerequisites

Install Homebrew first:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then install the required tools:

```bash
# Essential tools
brew install git stow

# Modern CLI tools
brew install bat eza zoxide fzf starship

# Terminal and editors
brew install --cask iterm2
brew install --cask zed
brew install vim

# Optional but recommended
brew install ripgrep fd tree
brew install node  # Includes npm

# Zsh enhancements (optional)
brew install zsh-syntax-highlighting zsh-autosuggestions
```

### Fonts

Install a Nerd Font for icons to display properly:

```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
```

Configure your terminal (iTerm2) to use one of these fonts.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/latiif/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Backup existing dotfiles** (if any):

   ```bash
   # Backup your current configs
   mv ~/.zshrc ~/.zshrc.backup 2>/dev/null
   mv ~/.vimrc ~/.vimrc.backup 2>/dev/null
   mv ~/.config/starship.toml ~/.config/starship.toml.backup 2>/dev/null
   ```

3. **Deploy dotfiles with Stow**:

   ```bash
   stow .
   ```

   This will create symlinks from your home directory to the dotfiles repository.

4. **Source the new zshrc**:

   ```bash
   source ~/.zshrc
   ```

5. **Install Vim plugins**:
   Open vim and run:
   ```
   :PlugInstall
   ```

## Configuration Files

### Zsh (.zshrc)

- Modern CLI tool integration (eza, bat, zoxide, fzf)
- Starship prompt
- Sensible ZSH options (auto-cd, history management)
- Completion system with case-insensitive matching
- macOS-specific utilities and aliases
- Git aliases
- NVM integration
- Go path configuration
- Syntax highlighting and auto-suggestions (optional)

### Vim (.vimrc)

- Plugin management with vim-plug (auto-installs)
- Go development support (vim-go)
- File explorer (NERDTree)
- Fuzzy finding (fzf.vim)
- Git integration (vim-fugitive, gitgutter)
- Status line (lightline)
- Auto-pairs, rainbow parentheses
- macOS clipboard integration

### Starship (starship.toml)

- Minimal, fast prompt
- Git status integration
- Language version indicators (Node, Python, Rust, Go)
- Custom styling with Catppuccin-inspired colors

### Zed (settings.json)

- Vim mode enabled
- System clipboard integration
- Format on save
- Indent guides
- Custom theme (One Dark / Gruvbox Light)
- Minimal UI configuration

### iTerm2 (DynamicProfiles)

- Custom color scheme
- Font configuration (FiraCode)
- Terminal settings
- Cursor configuration

## iTerm2 Setup

To use the iTerm2 configuration:

1. Open iTerm2 → Preferences → Profiles
2. At the bottom, click "Other Actions" → "Browse Dynamic Profiles"
3. This will open Finder to: `~/Library/Application Support/iTerm2/DynamicProfiles`
4. Create a symlink to your dotfiles iTerm2 profile:
   ```bash
   mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
   ln -sf ~/.config/iterm2/DynamicProfiles/profiles.json \
          ~/Library/Application\ Support/iTerm2/DynamicProfiles/
   ```
5. Restart iTerm2

## Customization

### Local Configuration

Create a `~/.zshrc.local` file for machine-specific settings that shouldn't be in version control:

```zsh
# Example ~/.zshrc.local
export CUSTOM_VAR="value"
alias custom-alias='some-command'
```

### Adding New Configurations

1. Add new configuration files to the dotfiles directory
2. Restow to update symlinks:
   ```bash
   cd ~/.dotfiles
   stow --restow .
   ```

## Maintenance

### Update Vim Plugins

```bash
vim +PlugUpdate +qall
```

### Update Homebrew Packages

```bash
brew update && brew upgrade
```

### Sync Dotfiles

```bash
cd ~/.dotfiles
git pull
stow --restow .
```

## Uninstallation

To remove all symlinks created by Stow:

```bash
cd ~/.dotfiles
stow -D .
```

## Tools Overview

| Tool         | Purpose         | Config File                       |
| ------------ | --------------- | --------------------------------- |
| **zsh**      | Shell           | `.zshrc`                          |
| **vim**      | Text editor     | `.vimrc`                          |
| **starship** | Shell prompt    | `.config/starship.toml`           |
| **zed**      | Code editor     | `.config/zed/settings.json`       |
| **iTerm2**   | Terminal        | `.config/iterm2/DynamicProfiles/` |
| **bat**      | cat replacement | Uses `$BAT_THEME`                 |
| **eza**      | ls replacement  | Aliased in zshrc                  |
| **zoxide**   | Smart cd        | Init in zshrc                     |
| **fzf**      | Fuzzy finder    | Custom opts in zshrc              |

## Key Bindings

### Zsh

- `Ctrl-R`: Search history with fzf
- `Ctrl-T`: Fuzzy file search
- `Opt-C`: Fuzzy directory search (cd)
- `→`: Accept auto-suggestion (if zsh-autosuggestions installed)

### Vim

- `Ctrl-T`: Toggle NERDTree
- `Ctrl-F`: Find current file in NERDTree
- `F2`: Toggle Tagbar
- `:F`: Fuzzy file search

### Zed

- Vim mode enabled
- Standard Zed keybindings apply

## License

Feel free to use and modify as needed!

## Credits

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/)
