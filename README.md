# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Contents

| Path | Purpose |
|------|---------|
| `~/.zshrc`, `~/.zprofile` | Zsh shell configuration |
| `~/.p10k.zsh` | Powerlevel10k prompt theme |
| `~/.config/jj/` | Jujutsu version control config |
| `~/.claude/CLAUDE.md` | Global Claude Code instructions |
| `~/.claude/rules/` | Topic-specific Claude rules |
| `~/.claude/skills/` | Custom Claude Code workflow skills |
| `~/.claude/settings.json` | Claude Code settings and plugins |

## Install

```sh
chezmoi init --apply https://github.com/pallotron/dotfiles
```

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
