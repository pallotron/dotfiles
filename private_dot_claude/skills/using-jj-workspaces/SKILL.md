---
name: using-jj-workspaces
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated jj workspaces with smart directory selection and safety verification
---

# Using jj Workspaces

## Overview

jj workspaces create isolated working copies sharing the same repository, allowing work on multiple changes simultaneously without switching.

**Core principle:** Workspaces must be siblings to the main repo — never inside it.

**Announce at start:** "I'm using the using-jj-workspaces skill to set up an isolated workspace."

## Why Siblings, Not Subdirectories

Placing a workspace inside the repo (e.g. `.worktrees/feature`) creates a repo-inside-a-repo situation. jj will warn about this, and the nested working copy gets snapshotted as regular files — polluting `jj status` with compiled artifacts, node_modules, etc. Always use a path outside the repo root.

## Directory Selection Process

### 1. Detect Project Name and Root

```bash
repo_root=$(jj root)
project=$(basename "$repo_root")
```

### 2. Check CLAUDE.md

```bash
grep -i "workspace.*director\|worktree.*director" "$repo_root/CLAUDE.md" 2>/dev/null
```

**If preference specified:** Use it without asking.

### 3. Default Location

Use a sibling directory next to the repo:

```
<parent-of-repo>/<project>-<feature-name>
```

Example: repo at `~/code/myapp` → workspace at `~/code/myapp-auth`

If the parent directory already has many repos and you want to keep things tidy, ask the user:

```
Where should I create the workspace?

1. ../myapp-<feature> (sibling directory, next to the repo)
2. ~/.local/share/jj-workspaces/myapp/<feature> (global location)

Which would you prefer?
```

## Creation Steps

### 1. Determine Path

```bash
repo_root=$(jj root)
project=$(basename "$repo_root")
parent=$(dirname "$repo_root")
path="$parent/$project-$FEATURE_NAME"
```

### 2. Create Workspace

```bash
# Create workspace at sibling path
jj workspace add "$path"
cd "$path"

# Describe the empty change that jj workspace add already created at @
# DO NOT run `jj new` here — workspace add already placed an empty change at @.
# Running jj new creates a second unnamed empty commit that causes `jj git push` to fail.
jj describe -m "wip: $FEATURE_NAME"
```

**Note:** Unlike git worktrees, jj workspaces don't require a branch name. The new workspace gets its own `@` commit at the tip of the current revision. Use `jj bookmark create $FEATURE_NAME` later if you need a named bookmark.

### 3. Run Project Setup

Auto-detect and run appropriate setup:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 4. Verify Clean Baseline

Run tests to ensure workspace starts clean:

```bash
# Examples - use project-appropriate command
npm test
cargo test
pytest
go test ./...
```

**If tests fail:** Report failures, ask whether to proceed or investigate.

**If tests pass:** Report ready.

### 5. Report Location

```
Workspace ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| CLAUDE.md specifies location | Use it |
| No preference | Use sibling `../project-feature` |
| Tests fail during baseline | Report failures + ask |
| No package.json/Cargo.toml | Skip dependency install |

## Cleanup

```bash
# Find the exact workspace name first — it's the directory basename, not a short label
jj workspace list

# Forget the workspace (from any workspace in the repo)
jj workspace forget coredns-netbox-persistent-zones   # example: full directory basename

# Remove the directory
rm -rf "$path"
```

**Important:** `jj workspace forget` takes the workspace name as shown by `jj workspace list` — the full directory basename (e.g. `myapp-feature`), not a short alias.

## Key jj vs git Differences

| Concept | git worktrees | jj workspaces |
|---------|--------------|----------------|
| Create | `git worktree add "$path" -b "$BRANCH"` | `jj workspace add "$path"` |
| Start work | (branch created automatically) | `jj new -m "wip: feature"` |
| List | `git worktree list` | `jj workspace list` |
| Remove | `git worktree remove` | `jj workspace forget` |
| Project root | `git rev-parse --show-toplevel` | `jj root` |
| Typical location | `.worktrees/` inside repo | sibling directory `../project-feature` |
| Named tracking | branch | bookmark (`jj bookmark create`) |

## Common Mistakes

### Placing workspace inside the repo

- **Problem:** Creates a repo-inside-a-repo. jj snapshots workspace files (compiled binaries, node_modules) as regular project files, polluting `jj status` and `jj diff`.
- **Fix:** Always use a path outside `jj root` — a sibling directory or global location.

### Running `jj new` after workspace creation

- **Problem:** `jj workspace add` already creates an empty change at `@`. Running `jj new` on top produces a *second* unnamed empty commit. When you later run `jj git push`, it fails: *"Won't push commit ... since it has no description"*. Fixing it requires a `jj rebase` to drop the extra commit.
- **Fix:** After `jj workspace add`, just run `jj describe -m "wip: ..."` to name the existing empty change. Never run `jj new` immediately after `jj workspace add`.

### Proceeding with failing tests

- **Problem:** Can't distinguish new bugs from pre-existing issues.
- **Fix:** Report failures, get explicit permission to proceed.

## Example Workflow

```
You: I'm using the using-jj-workspaces skill to set up an isolated workspace.

[repo_root = /Users/user/code/myapp, project = myapp]
[path = /Users/user/code/myapp-auth]
[jj workspace add /Users/user/code/myapp-auth]
[cd /Users/user/code/myapp-auth]
[jj describe -m "wip: auth feature"]   # describe the empty @ created by workspace add — do NOT jj new
[Run npm install]
[Run npm test - 47 passing]

Workspace ready at /Users/user/code/myapp-auth
Tests passing (47 tests, 0 failures)
Ready to implement auth feature
```

## Red Flags

**Never:**
- Create workspace inside the repo directory (`.worktrees/`, `worktrees/`, or any subdirectory)
- Run `jj new` after `jj workspace add` — it already creates an empty `@`; use `jj describe -m "..."` instead
- Skip baseline test verification
- Proceed with failing tests without asking
- Run `gh` CLI commands from the sibling workspace directory — it has no `.git`; run from the main repo

**Always:**
- Use a sibling path outside `jj root`
- Check CLAUDE.md first for location preference
- Run `jj describe -m "wip: ..."` (not `jj new`) immediately after creating the workspace
- Auto-detect and run project setup
- Verify clean test baseline
- Use `jj workspace list` to find the exact workspace name before `jj workspace forget`

## Integration

**Called by:**
- **brainstorming** (Phase 4) - REQUIRED when design is approved and implementation follows
- **subagent-driven-development** - REQUIRED before executing any tasks
- **executing-plans** - REQUIRED before executing any tasks
- Any skill needing isolated workspace

**Pairs with:**
- **finishing-a-development-branch** - REQUIRED for cleanup after work complete
