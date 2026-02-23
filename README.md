# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Contents

| Path | Purpose |
|------|---------|
| `~/.zshrc`, `~/.zprofile`, `~/.zshenv` | Zsh shell configuration |
| `~/.p10k.zsh` | Powerlevel10k prompt theme |
| `~/.vimrc` | Vim configuration |
| `~/.gitconfig` | Git identity, signing key, and settings |
| `~/.ssh/config` | SSH host aliases |
| `~/.config/jj/` | Jujutsu version control config |
| `~/.config/nvim/` | Neovim configuration |
| `~/.config/gh/` | GitHub CLI config |
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
chezmoi git -- add .
chezmoi git -- commit -m "add some config"
chezmoi git -- push
```

## Adding files with secrets

If a file contains API keys, tokens, or other secrets, use templates instead of storing values directly.

### 1. Add the secret to 1Password

Open 1Password and add a new field to the **dotfiles** item in the **Private** vault.

### 2. Add the file as a template

```sh
chezmoi add --template ~/.yourfile
```

If chezmoi warns about detected secrets when running a plain `chezmoi add`, stop and use `--template` instead.

### 3. Replace hardcoded values in the template

Edit the generated `.tmpl` file in the chezmoi source directory:

```sh
chezmoi edit ~/.yourfile
```

Replace each secret value with a `onepasswordRead` call:

```
export MY_API_KEY="{{ onepasswordRead "op://Private/dotfiles/MY_API_KEY" }}"
```

### 4. Verify the template renders correctly

```sh
chezmoi execute-template < ~/.local/share/chezmoi/dot_yourfile.tmpl
```

Check that the secrets are populated and no hardcoded values remain.

### 5. Commit and push

```sh
chezmoi git -- add .
chezmoi git -- commit -m "add yourfile with 1Password secret templating"
chezmoi git -- push
```
