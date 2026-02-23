# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Contents

| Path | Purpose |
|------|---------|
| `~/.zshrc`, `~/.zprofile`, `~/.zshenv` | Zsh shell configuration |
| `~/.p10k.zsh` | Powerlevel10k prompt theme |
| `~/.config/jj/` | Jujutsu version control config |
| `~/.claude/CLAUDE.md` | Global Claude Code instructions |
| `~/.claude/rules/` | Topic-specific Claude rules |
| `~/.claude/skills/` | Custom Claude Code workflow skills |
| `~/.claude/settings.json` | Claude Code settings and plugins |

## Restore on a new machine

### 1. Install dependencies

```sh
brew install chezmoi 1password-cli
```

### 2. Sign in to 1Password

```sh
op signin
```

Some secrets (API keys, tokens) are stored in 1Password and injected at apply time. Signing in first is required.

### 3. Apply dotfiles

```sh
chezmoi init --apply https://github.com/pallotron/dotfiles
```

This will render all templates with secrets pulled from 1Password and write the final files to your home directory.

## Update

```sh
chezmoi update
```

## Adding new files

```sh
chezmoi add ~/.some/config/file
chezmoi git add .
chezmoi git commit -m "add some config"
chezmoi git push
```
