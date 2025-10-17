# Git Hooks

This directory contains git hooks for the project.

## Available Hooks

### pre-push (MANDATORY REVIEW)

**Automatically blocks pushes until Codex review approves the changes.**

This is a **hard enforcement** - you cannot push without approval unless you explicitly skip with `--no-verify`.

#### Installation

```bash
# Copy hook to git hooks directory
cp .git-hooks/pre-push .git/hooks/pre-push

# Make executable
chmod +x .git/hooks/pre-push
```

#### How It Works

1. **Detects changes**: Compares your branch against tracking branch (or origin/main)
2. **Requests review**: Sends full diff to Codex via `codex` CLI with gpt-5-codex model
3. **Waits for verdict**: Review must include either:
   - `APPROVED: No blocking issues found` ✅
   - `BLOCKED: Critical issues must be fixed` ❌
4. **Enforces decision**:
   - If APPROVED: Push proceeds
   - If BLOCKED: Push rejected - you must fix issues
   - If neither: Treated as BLOCKED for safety
   - If timeout/error: Push rejected - cannot push without review

#### Usage

```bash
# Normal push - REQUIRES review approval
git push

# ⚠️  Skip review (use sparingly!)
git push --no-verify
```

**When to skip review**:
- Trivial documentation fixes
- Fixing typos
- Updating README only
- Emergency hotfixes (but review after!)

**Never skip review for**:
- Any code changes
- Configuration changes
- Test changes
- Build script changes

#### Requirements

**Required**:
- `codex` CLI installed and in PATH
- API credentials configured for codex CLI

**Optional but recommended**:
- `AGENTS.md` in repo root - provides review context
- `reviews/pre-push/` directory - reviews are archived here

#### Review Archive

If `reviews/pre-push/` directory exists, all reviews are saved with format:
```
reviews/pre-push/20251016_143022_feature-name_APPROVED.md
reviews/pre-push/20251016_143155_bugfix_BLOCKED.md
```

This provides audit trail of all pre-push reviews.

#### What Codex Reviews

The pre-push review checks for:

1. **Contract violations**: MUST/MUST NOT/INVARIANT violations
2. **Security issues**: Path traversal, injection, auth bypass
3. **Obvious bugs**: Logic errors, null derefs, off-by-one
4. **Code quality**: Major style violations, missing docs

This is a **quick safety check**, not a final thorough review. Final review happens during PR.

#### Troubleshooting

**Hook not running**:
```bash
# Check if installed
ls -la .git/hooks/pre-push

# Check if executable
chmod +x .git/hooks/pre-push
```

**Codex command not found**:
```bash
# Install codex CLI
npm install -g @anthropic-ai/codex-cli

# Or check if in PATH
which codex
```

**Review timing out**:
- Timeout is 120 seconds
- Large diffs may need more time
- Consider breaking up large changes
- Or skip review and get manual review in PR

**Review missing APPROVED/BLOCKED**:
- Review format may be incorrect
- Codex may not have followed instructions
- Treated as BLOCKED for safety
- Try again or skip with --no-verify

---

## Manual Reviews (via MCP)

Claude Code can also request reviews manually when needed:

### Via Review MCP Server

```bash
# From command line
codex exec --agent-file AGENTS.md -m gpt-5-codex < review_request.txt

# Or via MCP tool in Claude Code
# (Review MCP server must be running)
```

### When to Request Manual Review

- **Before implementing**: "Is this approach sound?"
- **During implementation**: "This part is complex, does it look right?"
- **After implementation**: "Final check before PR"
- **When stuck**: "I can't figure out why this doesn't work"

Manual reviews are **voluntary** and complementary to the **mandatory** pre-push review.

---

## Creating Review Directory

To enable review archiving:

```bash
mkdir -p reviews/pre-push
echo "# Pre-push Reviews" > reviews/pre-push/README.md
echo "reviews/" >> .gitignore  # Don't commit reviews to repo
```

Reviews will then be saved locally for your reference.

---

## Questions?

- Check `AGENTS.md` for what reviewers look for
- Check `docs/WORKFLOW.md` for PR review process
- Ask user if hook behavior needs adjustment
