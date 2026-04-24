# dotfiles

Personal development environment configuration using a Monokai Pro theme throughout.

## Overview

| Tool | Role |
|------|------|
| [WezTerm](https://wezfurlong.org/wezterm/) | Terminal emulator |
| [Zsh](https://www.zsh.org/) | Shell |
| [Starship](https://starship.rs/) | Shell prompt |
| [Neovim](https://neovim.io/) + [LazyVim](https://lazyvim.org/) | Editor |
| [GitUI](https://github.com/extrawurst/gitui) | Git TUI |
| [OpenCode](https://github.com/opencode-ai/opencode) | AI coding assistant (terminal) |

## Required Programs

### Core

| Program | Version | Notes |
|---------|---------|-------|
| zsh | 5.8+ | Shell |
| git | 2.x | With Git LFS |
| [WezTerm](https://wezfurlong.org/wezterm/installation.html) | latest | Terminal |
| [Neovim](https://neovim.io/) | 0.9+ | Editor |
| [Starship](https://starship.rs/) | latest | Prompt |
| [GitUI](https://github.com/extrawurst/gitui/releases) | latest | Git TUI |

### Fonts

The following fonts must be installed on your system:

- **MonoLisa Nerd Font** — primary monospace font (commercial)
- **Line Seed JP** — Japanese character support
- **BIZ UDGothic** — Japanese character fallback

> If MonoLisa Nerd Font is unavailable, edit the `font` section in `.wezterm.lua` to use another Nerd Font (e.g., `JetBrainsMono Nerd Font`).

### Optional

| Program | Notes |
|---------|-------|
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager |
| [OpenCode](https://github.com/opencode-ai/opencode) | Terminal-based AI coding assistant |
| git-lfs | Large file support |

---

## Setup

### macOS

```sh
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install core tools
brew install git git-lfs neovim starship gitui

# 3. Install WezTerm
brew install --cask wezterm

# 4. Install fonts (via Homebrew Cask or manually)
brew install --cask font-biz-udgothic

# 5. Install OpenCode
brew install opencode-ai/tap/opencode

# 6. Clone this repo
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles

# 7. Run the install script
bash ~/dotfiles/script/install.sh
```

### Ubuntu / WSL

```sh
# 1. Install system packages
sudo apt update && sudo apt install -y git git-lfs zsh curl unzip

# 2. Install Neovim (latest AppImage)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# /opt/nvim-linux-x86_64/bin is added to PATH automatically on Linux

# 3. Install Starship
curl -sS https://starship.rs/install.sh | sh

# 4. Install GitUI
curl -s https://api.github.com/repos/extrawurst/gitui/releases/latest \
  | grep "browser_download_url.*gitui-linux-x86_64.tar.gz" \
  | cut -d'"' -f4 \
  | xargs curl -L -o /tmp/gitui.tar.gz
sudo tar -xzf /tmp/gitui.tar.gz -C /usr/local/bin

# 5. Install WezTerm (Ubuntu)
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
  | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install -y wezterm

# 6. Install OpenCode
curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/refs/heads/main/install | bash

# 7. Clone this repo
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles

# 8. Run the install script
bash ~/dotfiles/script/install.sh

# 9. Change default shell to zsh (if needed)
chsh -s $(which zsh)
```

### Windows (WSL2)

WezTerm on Windows connects to WSL2 automatically (`default_domain = "WSL:{DistroName}"`).

```powershell
# 1. Install WSL2 with Ubuntu 24.04
wsl --install -d {DistroName}

# 2. Install WezTerm for Windows
winget install wez.wezterm
```

Then inside the WSL2 terminal, follow the **Ubuntu** steps above.

WezTerm runs on the Windows side (not inside WSL), so its config must be symlinked from Windows. Run the following in **PowerShell as Administrator**:

```powershell
New-Item -Path "$env:USERPROFILE\.wezterm.lua" `
         -ItemType SymbolicLink `
         -Value "\\wsl.localhost\{DistroName}\home\{UserName}\dotfiles\wezterm\.wezterm.lua"
```

> The WezTerm config sets `default_domain = "WSL:{DistroName}"`. Adjust this in `.wezterm.lua` if your distro name is different.

---

## Installation Script

```sh
bash ~/dotfiles/script/install.sh
```

The script:
- Reads `script/structure.map` to determine symlink mappings
- Creates `~/.dotbackup/` and moves any existing conflicting files there
- Symlinks each config to its target location in `$HOME`

Use `--debug` / `-d` for verbose output.

---

## Syncing

```sh
sync   # alias for: git -C ~/dotfiles pull
```

---

## Key Bindings

### WezTerm (`LEADER` = Ctrl+Q)

| Key | Action |
|-----|--------|
| `LEADER` + `c` | New tab |
| `LEADER` + `q` | Close tab |
| `LEADER` + `n` / `p` | Next / previous tab |
| `LEADER` + `w` | Tab navigator |
| `LEADER` + `v` / `s` | Split horizontal / vertical |
| `LEADER` + `x` | Close pane |
| `LEADER` + `z` | Toggle pane zoom |
| `LEADER` + `h/j/k/l` | Navigate panes |
| `LEADER` + `H/J/K/L` | Resize pane |
| `Ctrl+Shift+V` | Paste from clipboard |

### Neovim (`<leader>` = Space)

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<leader>gg` | Toggle GitUI (float) |

---

## Structure

```
dotfiles/
├── zsh/                   # Zsh configuration
│   └── .zshrc
├── wezterm/               # WezTerm configuration
│   └── .wezterm.lua
├── git/                   # Git configuration
│   └── .gitconfig
├── nvim/                  # Neovim + LazyVim configuration
│   ├── lua/config/        # options, keymaps, autocmds, lazy bootstrap
│   └── lua/plugins/       # plugin specs
├── starship/              # Starship prompt configuration
│   └── starship.toml
├── gitui/                 # GitUI configuration
│   ├── key_bindings.ron
│   └── theme.ron
├── opencode                 # OpenCode configuration
│   └── .opencode.json
├── monokai-pro-palette.toml  # Monokai Pro color reference
└── script/
    ├── install.sh         # Symlink installer
    └── structure.map      # Source -> target symlink mappings
```
