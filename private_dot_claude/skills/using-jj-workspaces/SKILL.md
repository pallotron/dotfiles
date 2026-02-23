---
name: using-jj-workspaces
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated jj workspaces with smart directory selection and safety verification
---

# Using jj Workspaces

## Overview

jj workspaces create isolated working copies sharing the same repository, allowing work on multiple changes simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

**Announce at start:** "I'm using the using-jj-workspaces skill to set up an isolated workspace."

## Directory Selection Process

Follow this priority order:

### 1. Check Existing Directories

```bash
# Check in priority order
ls -d .worktrees 2>/dev/null     # Preferred (hidden)
ls -d worktrees 2>/dev/null      # Alternative
```

**If found:** Use that directory. If both exist, `.worktrees` wins.

### 2. Check CLAUDE.md

```bash
grep -i "worktree.*director\|workspace.*director" CLAUDE.md 2>/dev/null
```

**If preference specified:** Use it without asking.

### 3. Ask User

If no directory exists and no CLAUDE.md preference:

```
No workspace directory found. Where should I create workspaces?

1. .worktrees/ (project-local, hidden)
2. ~/.config/superpowers/worktrees/<project-name>/ (global location)

Which would you prefer?
```

## Safety Verification

### For Project-Local Directories (.worktrees or worktrees)

**MUST verify directory is ignored before creating workspace:**

```bash
# Check .gitignore directly (jj respects .gitignore files)
grep -q "^\.worktrees" .gitignore 2>/dev/null || grep -q "^worktrees" .gitignore 2>/dev/null
```

**If NOT ignored:**

1. Add appropriate line to `.gitignore`
2. Commit with `jj describe` or `jj commit`
3. Proceed with workspace creation

**Why critical:** Prevents accidentally tracking workspace contents.

### For Global Directory (~/.config/superpowers/worktrees)

No `.gitignore` verification needed — outside project entirely.

## Creation Steps

### 1. Detect Project Name

```bash
project=$(basename "$(jj root)")
```

### 2. Create Workspace

```bash
# Determine full path
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$FEATURE_NAME"
    ;;
  ~/.config/superpowers/worktrees/*)
    path="~/.config/superpowers/worktrees/$project/$FEATURE_NAME"
    ;;
esac

# Create workspace (defaults to current @- revision)
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
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check CLAUDE.md → Ask user |
| Directory not ignored | Add to `.gitignore` + commit |
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
| Ignore check | `git check-ignore -q` | `grep .gitignore` |
| Named tracking | branch | bookmark (`jj bookmark create`) |

## Common Mistakes

### Skipping ignore verification

- **Problem:** Workspace contents get tracked, pollute jj status
- **Fix:** Always grep `.gitignore` before creating project-local workspace

### Assuming directory location

- **Problem:** Creates inconsistency, violates project conventions
- **Fix:** Follow priority: existing > CLAUDE.md > ask

### Forgetting to run `jj new` after workspace creation

- **Problem:** Working directly on the parent commit, not an isolated change
- **Fix:** Always run `jj new -m "wip: ..."` immediately after entering the new workspace

### Proceeding with failing tests

- **Problem:** Can't distinguish new bugs from pre-existing issues
- **Fix:** Report failures, get explicit permission to proceed

## Example Workflow

```
You: I'm using the using-jj-workspaces skill to set up an isolated workspace.

[Check .worktrees/ - exists]
[Verify ignored - grep .gitignore confirms .worktrees is listed]
[Create workspace: jj workspace add .worktrees/auth]
[cd .worktrees/auth]
[jj new -m "wip: auth feature"]
[Run npm install]
[Run npm test - 47 passing]

Workspace ready at /Users/user/myproject/.worktrees/auth
Tests passing (47 tests, 0 failures)
Ready to implement auth feature
```

## Red Flags

**Never:**
- Create workspace without verifying it's ignored (project-local)
- Skip `jj new` after workspace creation (work directly on parent commit)
- Skip baseline test verification
- Proceed with failing tests without asking
- Assume directory location when ambiguous
- Skip CLAUDE.md check

**Always:**
- Follow directory priority: existing > CLAUDE.md > ask
- Verify directory is ignored for project-local
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
