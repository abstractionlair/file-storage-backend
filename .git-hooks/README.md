# Git Hooks

This directory contains git hooks for the project.

## Available Hooks

### pre-push

Automatically runs Codex review before pushing code.

**Installation**:
```bash
cp .git-hooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-push
```

**Usage**:
```bash
# Normal push - triggers automatic review
git push

# Skip review for trivial changes
git push --no-verify
```

**Behavior**:
1. Compares your branch against tracking branch (or origin/main)
2. Sends diff to Codex via `codex` CLI
3. Shows review response
4. Blocks push if critical issues found (unless you confirm)
5. Saves review to `reviews/pre-push/` if directory exists

**Requirements**:
- `codex` CLI installed and in PATH
- OpenAI API key configured

**Optional**:
- If `AGENTS.md` exists, it will be loaded for review context
- If `reviews/pre-push/` directory exists, reviews will be archived there

## Manual Reviews

Claude Code can also request reviews manually via the review MCP server:

```javascript
// In Claude Code, call via MCP
codex_review({
  prompt: "Review this approach before I implement...",
  model: "gpt-5-codex",
  review_type: "code",
  agent_file: "/path/to/AGENTS.md"
})
```

This is useful when:
- Approaching a complex problem
- Unsure about design decision
- Want validation before significant work
- Implementing critical functionality
