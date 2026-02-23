# Tools

## Runtime/Environment Management
I use **mise** for managing tool versions and environment variables.
- Use `mise install` to set up project runtimes
- Check `.mise.toml` or `.tool-versions` for required versions
- Prefer `mise run <task>` for project tasks when a mise config exists
- If a `.mise.toml` or `.tool-versions` file is present, assume mise is the version manager and use it accordingly

## Package Managers
- Python: prefer `uv` over pip/pipenv
- System installs: prefer `brew` on macOS

## Build Tools
- Prefer `make` when a Makefile exists

## Shell
- I use `zsh`
- Prefer POSIX-compatible scripts unless bash-specific features are needed
