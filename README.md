# Dotfiles Repository

This repository contains my personal dotfiles managed with GNU Stow.

## About Dotfiles

Dotfiles are configuration files (often starting with a dot, hence the name)
used to personalize applications and settings on Unix-like systems. This
repository houses various configuration files for tools and applications I use
regularly.

### Prerequisites

Before using these dotfiles, ensure the following software is installed on your
system:

1. **Git**: Version control system used for cloning and managing this
   repository.
   - Install Git:
     - Debian/Ubuntu:
       ```bash
       sudo apt-get install git
       ```
     - macOS (via Homebrew):
       ```bash
       brew install git
       ```

2. **GNU Stow**: Software used to manage symbolic links for dotfiles.
   - Install GNU Stow:
     - Debian/Ubuntu:
       ```bash
       sudo apt-get install stow
       ```
     - macOS (via Homebrew):
       ```bash
       brew install stow
       ```

3. **Bat**: A cat clone with syntax highlighting and Git integration.
   - Install Bat:
     - Debian/Ubuntu:
       ```bash
       sudo apt-get install bat
       ```
     - macOS (via Homebrew):
       ```bash
       brew install bat
       ```

4. **Starship**: Minimal, fast, and customizable prompt for any shell.
   - Install Starship:
     - Debian/Ubuntu:
       ```bash
       curl -fsSL https://starship.rs/install.sh | bash
       ```
     - macOS (via Homebrew):
       ```bash
       brew install starship
       ```

5. **Tmux**: Terminal multiplexer that enables multiple terminals in a single
   window.
   - Install Tmux:
     - Debian/Ubuntu:
       ```bash
       sudo apt-get install tmux
       ```
     - macOS (via Homebrew):
       ```bash
       brew install tmux
       ```

6. **Vim**: Highly configurable text editor often used in terminal environments.
   - Install Vim:
     - Debian/Ubuntu:
       ```bash
       sudo apt-get install vim
       ```
     - macOS (via Homebrew):
       ```bash
       brew install vim
       ```

7. **FiraMono Nerd Font**: Make sure [FiraMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraMono.zip) is installed on your system.

8. **Other**: Install these commands:
   ```bash
    sudo apt-get install exa zoxide
   ```

Ensure all the above dependencies are installed before proceeding with setting
up the dotfiles. These tools are essential for a seamless experience with the
provided configurations.

### Setup

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/latiif/dotfiles.git ~/.dotfiles
   ```

1. **Navigate to the Repository**:
   ```bash
   cd ~/.dotfiles
   ```
1. **Deploy Dotfiles**:
   ```bash
   stow .
   ```
