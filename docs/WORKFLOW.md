# Implementation Workflow

**Purpose**: Step-by-step workflow for implementing features from specs.

---

## Overview

This document describes the standard workflow for implementing features in the file-storage-backend. Follow this process for every feature to ensure consistency, quality, and proper documentation.

## Prerequisites

Before starting implementation:
- [ ] Spec document exists in `specs/doing/`
- [ ] Spec has been reviewed by GPT-5
- [ ] Behavioral contract is complete (MUST/MUST NOT/INVARIANTS)
- [ ] Test scenarios are defined
- [ ] You've read and understood the entire spec

## Phase 1: Prepare Development Environment

### 1.1 Create Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feature/[feature-name]
```

**Naming convention**: `feature/file-operations`, `fix/error-handling`, `refactor/registry-format`

### 1.2 Read All Relevant Documentation

In order:
1. The spec document for this feature (`specs/doing/[feature].md`)
2. Related specs in `specs/done/` if building on existing work
3. `docs/STANDARDS.md` for code style requirements
4. `docs/TESTING.md` for test requirements

### 1.3 Identify Dependencies

Check if implementation requires:
- New dependencies (add to `requirements.txt` or `package.json`)
- Changes to existing interfaces
- Updates to other modules

**If yes**: Flag to user for discussion before proceeding.

---

## Phase 2: Test-First Implementation

### 2.1 Write Contract Tests FIRST

**Before writing any implementation code**, create tests from the behavioral contract.

Create: `tests/contracts/test_[feature]_contract.py`

```python
"""
Contract tests for [feature name].

These tests verify the MUST/MUST NOT/INVARIANTS from the spec.
Every requirement in the behavioral contract must have a test here.
"""

def test_must_[behavior]():
    """MUST: [exact text from spec]"""
    # Test implementation
    pass

def test_must_not_[behavior]():
    """MUST NOT: [exact text from spec]"""
    # Test that forbidden behavior raises error
    pass

def test_invariant_[property]():
    """INVARIANT: [exact text from spec]"""
    # Test that property always holds
    pass
```

**Critical**: Test names and docstrings should quote the spec exactly. This creates traceability.

### 2.2 Run Contract Tests (Should FAIL)

```bash
pytest tests/contracts/test_[feature]_contract.py -v
```

All tests should fail because implementation doesn't exist yet. This proves tests are actually testing something.

### 2.3 Implement Minimum to Pass Contract Tests

Write the simplest implementation that makes contract tests pass.

**Don't over-engineer**. If spec says "MUST create file", just create the file. Don't add caching, optimization, or features not in the spec.

### 2.4 Run Contract Tests (Should PASS)

```bash
pytest tests/contracts/test_[feature]_contract.py -v
```

All contract tests should now pass. If not, fix implementation until they do.

### 2.5 Write Unit Tests

Now that contract tests pass, add unit tests for implementation details:

Create: `tests/unit/test_[module].py`

```python
"""
Unit tests for [module name].

These tests verify internal behavior, edge cases, and implementation details
not covered by contract tests.
"""

def test_[specific_internal_behavior]():
    """Test that [internal detail] works correctly"""
    pass
```

### 2.6 Write Integration Tests

Create end-to-end tests that exercise the full feature:

Create: `tests/integration/test_[feature]_integration.py`

```python
"""
Integration tests for [feature name].

These tests verify the feature works correctly in realistic scenarios
with all components interacting.
"""

def test_[realistic_scenario]():
    """Test [feature] in [realistic context]"""
    pass
```

---

## Phase 3: Code Quality

### 3.1 Run All Tests

```bash
# All tests
pytest

# With coverage
pytest --cov=src --cov-report=term-missing
```

**Requirement**: 100% coverage of new code.

### 3.2 Check Code Quality

```bash
# Linting
flake8 src/ tests/

# Type checking
mypy src/

# Formatting
black src/ tests/ --check
```

Fix any issues found.

### 3.3 Update Documentation

If you added/changed:
- **Public API**: Update docstrings
- **Behavior**: Update relevant docs in `docs/`
- **Usage**: Add examples to README if needed

---

## Phase 4: Create Pull Request

### 4.1 Commit Changes

```bash
git add .
git commit -m "[Brief description]

[Detailed explanation of what was implemented and why]

Implements: specs/doing/[feature].md

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Commit message format**:
- First line: Brief (50 chars or less)
- Blank line
- Detailed explanation of changes
- Reference to spec
- Attribution

### 4.2 Push Feature Branch

```bash
# This will trigger pre-push git hook for Codex review
git push origin feature/[feature-name]

# If Codex review finds issues, fix them before continuing
# If trivial change, can skip review with:
git push origin feature/[feature-name] --no-verify
```

### 4.3 Create PR with Evidence Report

Use the PR template from `docs/PR_TEMPLATE.md`:

```markdown
## Feature: [Name]

**Implements**: specs/doing/[feature].md

## Evidence Report

### Contract Test Results
- [ ] All MUST behaviors tested and passing
- [ ] All MUST NOT behaviors tested and properly rejected
- [ ] All INVARIANTS tested and verified

Test output:
```
[Paste pytest output showing all contract tests passing]
```

### Unit Test Results
- Coverage: [percentage]%
- All tests passing: [yes/no]

### Integration Test Results
- Scenario 1: [result]
- Scenario 2: [result]
- ...

### Sample Outputs

Example 1: [scenario description]
```
[Input]
[Output]
[Verification that behavior matches spec]
```

### Deviations from Spec

[If any deviations from spec were necessary, list them here with justification]
OR
None - implementation matches spec exactly.

### Review Checklist

- [ ] All contract tests passing
- [ ] 100% code coverage of new code
- [ ] All linting/type checks passing
- [ ] Documentation updated
- [ ] No TODO comments remaining
- [ ] Codex review passed
```

### 4.4 Request Review

Tag in PR:
- `needs:codex-review` - for code review
- `needs:human-review` - for final evidence review

---

## Phase 5: Address Feedback

### 5.1 Codex Review

Codex will review and leave comments. For each comment:

1. **Understand the issue**: Read carefully, check spec if needed
2. **Fix the code**: Address the underlying problem
3. **Add tests**: If issue reveals a gap in tests
4. **Respond**: Comment explaining what you fixed

### 5.2 Human Review

User reviews evidence report (not code). If changes requested:

1. **Clarify what behavior needs to change**
2. **Update spec if needed** (don't implement without updated spec)
3. **Make changes**
4. **Re-run all tests**
5. **Update evidence report**

### 5.3 Approval

Once approved:
- Move spec from `specs/doing/` to `specs/done/`
- Merge PR (user will do this, not you)
- Delete feature branch

---

## Phase 6: Post-Merge

### 6.1 Verify Merge

```bash
git checkout main
git pull origin main
```

Verify your changes are in main and all tests still pass.

### 6.2 Update Local Knowledge

If implementation revealed:
- Spec was wrong: Update spec in `specs/done/`
- New pattern discovered: Document in `docs/STANDARDS.md`
- Bug found: Add to `docs/KNOWN_BUGS.md`

---

## Common Scenarios

### Scenario: Spec is Ambiguous

**Stop immediately**. Do not guess.

1. Document the ambiguity clearly
2. Flag to user with specific question
3. Wait for spec update
4. Resume once clarified

### Scenario: Tests Reveal Spec Bug

1. Document what's wrong with spec
2. Flag to user
3. User updates spec in Claude Projects
4. Resume with corrected spec

### Scenario: Can't Make Tests Pass

1. Review contract tests - are they testing the right thing?
2. Review implementation - does it match spec?
3. If stuck: Document where you're stuck, flag to user

### Scenario: Context Compaction

If context compacts mid-implementation:

1. Re-read the spec document (survives compaction)
2. Check `artifacts/decisions/` for any decision artifacts
3. Check git log for recent commits
4. If still unclear, ask user

---

## Anti-Patterns to Avoid

### ❌ Implementing Without Spec
Never start coding without a spec in `specs/doing/`.

### ❌ Tests After Code
Always write contract tests before implementation.

### ❌ Deviating from Spec Without Discussion
If you think spec is wrong, discuss with user. Don't silently "fix" it.

### ❌ Skipping Tests
Every MUST/MUST NOT/INVARIANT needs a test. No exceptions.

### ❌ Incomplete Evidence Reports
Evidence report must show actual test results, not summaries.

### ❌ Leaving TODOs
Resolve all TODOs before creating PR. No "we'll fix this later."

---

## Quick Reference

**Starting feature**:
```bash
git checkout -b feature/[name]
# Write contract tests
# Implement
# Run tests
```

**Creating PR**:
```bash
git commit -m "[description]"
git push origin feature/[name]
# Create PR with evidence report
```

**After approval**:
```bash
# User merges
git checkout main
git pull origin main
# Move spec to done/
```

---

## Questions?

- Check `docs/STANDARDS.md` for code style
- Check `docs/TESTING.md` for test requirements
- Check spec document for behavior questions
- Ask user if still unclear

**Remember**: When in doubt, ask. Don't guess.
