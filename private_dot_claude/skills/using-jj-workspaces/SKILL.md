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

# Start a new change to work on
jj new -m "wip: $FEATURE_NAME"
```

**Note:** Unlike git worktrees, jj workspaces don't require a branch name. The new workspace gets its own `@` commit. Use `jj bookmark create $FEATURE_NAME` later if you need a named bookmark.

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
# Forget the workspace (from any workspace)
jj workspace forget $WORKSPACE_NAME

# Remove the directory
rm -rf "$path"
```

List workspaces with `jj workspace list`.

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

### Forgetting to run `jj new` after workspace creation

- **Problem:** Working directly on the parent commit, not an isolated change.
- **Fix:** Always run `jj new -m "wip: ..."` immediately after entering the new workspace.

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
[jj new -m "wip: auth feature"]
[Run npm install]
[Run npm test - 47 passing]

Workspace ready at /Users/user/code/myapp-auth
Tests passing (47 tests, 0 failures)
Ready to implement auth feature
```

## Red Flags

**Never:**
- Create workspace inside the repo directory (`.worktrees/`, `worktrees/`, or any subdirectory)
- Skip `jj new` after workspace creation (work directly on parent commit)
- Skip baseline test verification
- Proceed with failing tests without asking

**Always:**
- Use a sibling path outside `jj root`
- Check CLAUDE.md first for location preference
- Run `jj new` immediately after entering the new workspace
- Auto-detect and run project setup
- Verify clean test baseline

## Integration

**Called by:**
- **brainstorming** (Phase 4) - REQUIRED when design is approved and implementation follows
- **subagent-driven-development** - REQUIRED before executing any tasks
- **executing-plans** - REQUIRED before executing any tasks
- Any skill needing isolated workspace

**Pairs with:**
- **finishing-a-development-branch** - REQUIRED for cleanup after work complete
