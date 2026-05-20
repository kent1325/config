# Mac config

My personal Mac setup: zsh + oh-my-posh + Ghostty + VS Code + Raycast, all installed and configured by one script.

## What's inside

```
config/
├── install.sh          # The one command that sets up a Mac
├── scripts/            # One script per setup step
├── brew/Brewfile       # All brews, casks, and VS Code extensions
├── zsh/                # .zshrc + oh-my-posh theme
├── git/                # .gitconfig
├── ghostty/            # Ghostty terminal config
├── vscode/             # settings.json + keybindings
└── raycast/            # Raycast config export
```

## Setup on a new Mac

```bash
git clone https://github.com/<you>/config.git ~/Code/config
cd ~/Code/config
./install.sh
```

That's it. The script handles everything below.

## What `./install.sh` does, step by step

It runs these in order. Each step is **idempotent** — safe to re-run.

### 1. `brew` — install Homebrew + everything in the Brewfile

```bash
./install.sh brew
```

- Installs Homebrew if it's missing (this also installs Xcode Command Line Tools).
- Runs `brew bundle` against `brew/Brewfile`, which installs all CLI tools, GUI apps, and VS Code extensions in one go.

### 2. `shell` — make zsh + oh-my-posh ready to use

```bash
./install.sh shell
```

- Confirms `oh-my-posh` and the zsh plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`) are installed.
- Sets zsh as the default login shell with `chsh` if it isn't already.

### 3. `symlinks` — link dotfiles from the repo into `$HOME`

```bash
./install.sh symlinks
```

Creates these symlinks (existing files are backed up to `~/.dotfiles-backup/<timestamp>/`):

| Repo file | Linked to |
|---|---|
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/ZSHThemes.json` | `~/ZSHThemes.json` |
| `git/.gitconfig` | `~/.gitconfig` |
| `ghostty/config` | `~/.config/ghostty/config` |

Symlinks (rather than copies) mean editing the repo file is the same as editing `~/<file>`.

### 4. `vscode` — link VS Code settings + keybindings

```bash
./install.sh vscode
```

- Symlinks `vscode/settings.json` and `vscode/keybindings(mac).json` into `~/Library/Application Support/Code/User/`.
- VS Code extensions are already installed by the `brew` step (they're listed as `vscode "..."` lines in the Brewfile).

### 5. `raycast` — import the Raycast config

```bash
./install.sh raycast
```

- Opens the newest `.rayconfig` file in `raycast/`, which prompts Raycast to merge it.
- You confirm the import in the Raycast dialog.


## Useful commands

```bash
./install.sh                    # Run everything
./install.sh --list             # Show all steps
./install.sh brew shell         # Run only specific steps
```

## Updating the repo from the current machine

After installing or changing something, regenerate the Brewfile:

```bash
brew bundle dump --file=brew/Brewfile --force --describe
```

To re-capture other configs:

```bash
cp ~/.zshrc                                                       zsh/.zshrc
cp ~/ZSHThemes.json                                               zsh/ZSHThemes.json
cp ~/.gitconfig                                                   git/.gitconfig
cp ~/.config/ghostty/config                                       ghostty/config
cp "$HOME/Library/Application Support/Code/User/settings.json"    vscode/settings.json
cp "$HOME/Library/Application Support/Code/User/keybindings.json" "vscode/keybindings(mac).json"
```