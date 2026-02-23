# Version Control

I use **Jujutsu (jj)**, not git. Before running any VCS commands, check if the repo is jj-enabled by looking for a `.jj/` directory. If it exists, always use `jj` commands instead of `git`:

- `jj status` instead of `git status`
- `jj diff` instead of `git diff`
- `jj log` instead of `git log`
- `jj new` before starting new work
- `jj describe -m "msg"` instead of `git commit`
- `jj git push` instead of `git push`
- `jj op undo` to undo the last operation

Never use `git` commands in a jj-enabled repo unless explicitly asked.
