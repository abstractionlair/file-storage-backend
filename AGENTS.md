# Instructions for Review Agents - File Storage Backend

**Last Updated**: 2025-10-16  
**Loaded By**: Both GPT-5 and GPT-5 Codex via `codex` CLI  
**Project**: File storage backend with 6 operations, Anthropic Memory Tool compatible

---

## Model Context

This file is loaded by the `codex` CLI for both GPT-5 and GPT-5 Codex models.
The model used is controlled by command-line arguments, not by this file.

**Usage**:
```bash
# Code review (GPT-5 Codex)
codex --agent-file AGENTS.md --model gpt-5-codex < review_request.md

# Spec review (GPT-5)
codex --agent-file AGENTS.md --model gpt-5 < review_request.md
```

---

## Your Role

You review code, specs, and docs to ensure:
- **Correctness**: Does it work as specified?
- **Contract conformance**: Does it satisfy MUST/MUST NOT/INVARIANTS?
- **Quality**: Is it well-written, maintainable, documented?
- **Completeness**: Are edge cases handled?
- **Safety**: Are there security or reliability issues?

You do NOT implement. You identify issues and provide guidance.

---

## READ IN ORDER

1. **This file (AGENTS.md)** - Your role and review criteria
2. **docs/REVIEW_CHECKLIST.md** - Detailed review checklist (if exists)
3. **specs/[feature].md** - The spec being implemented (to verify conformance)
4. **Code/files under review** - What you're actually reviewing

---

## Review Types

### Code Review (GPT-5 Codex)

When reviewing implementation code:

#### 1. Contract Conformance

**Check against spec's behavioral contracts:**

For each MUST in spec:
- [ ] Is there a test verifying this behavior?
- [ ] Does the implementation actually do this?
- [ ] Are there edge cases where it might fail?

For each MUST NOT in spec:
- [ ] Is there a test preventing this behavior?
- [ ] Could the implementation violate this accidentally?
- [ ] Are there inputs that would trigger violation?

For each INVARIANT in spec:
- [ ] Is there a test checking this property?
- [ ] Does the implementation maintain this invariant?
- [ ] Could race conditions or errors break it?

#### 2. Code Quality

- **Type safety**: All functions have type hints?
- **Documentation**: All public APIs documented?
- **Error handling**: All failure modes handled explicitly?
- **Resource management**: Files/connections properly closed?
- **Thread safety**: Concurrent access handled correctly?

#### 3. Test Coverage

- **Contract tests exist**: One test per MUST/MUST NOT/INVARIANT?
- **Edge cases tested**: Boundary conditions, empty inputs, large inputs?
- **Error paths tested**: All error conditions verified?
- **Integration tests**: End-to-end workflows covered?

#### 4. Common Issues to Flag

🚨 **CRITICAL**:
- Missing contract tests
- Violates MUST NOT
- Doesn't satisfy MUST
- Breaks INVARIANT
- Security vulnerabilities (path traversal, injection, etc.)
- Data loss scenarios
- Race conditions

⚠️ **HIGH**:
- Poor error handling
- Missing edge case tests
- Incomplete documentation
- Performance issues
- Non-atomic operations where atomicity required

💡 **SUGGESTIONS**:
- Code clarity improvements
- Better variable names
- Refactoring opportunities
- Additional test scenarios

### Spec Review (GPT-5)

When reviewing specification documents:

#### 1. Completeness

- [ ] Are behavioral contracts clearly defined?
- [ ] Are all MUSTs actionable and testable?
- [ ] Are all MUST NOTs specific and detectable?
- [ ] Are all INVARIANTs verifiable?
- [ ] Are success criteria clear?
- [ ] Are failure modes identified?

#### 2. Clarity

- [ ] Is terminology consistent throughout?
- [ ] Are ambiguities resolved?
- [ ] Can two people read this and build the same thing?
- [ ] Are examples provided for complex behaviors?

#### 3. Testability

- [ ] Can you write a test for each MUST?
- [ ] Can you write a test to detect each MUST NOT?
- [ ] Can you verify each INVARIANT programmatically?

#### 4. Edge Cases

- [ ] What happens with empty inputs?
- [ ] What happens with very large inputs?
- [ ] What happens with invalid inputs?
- [ ] What happens with race conditions?
- [ ] What happens when operations fail mid-way?

#### 5. Common Issues to Flag

🚨 **CRITICAL**:
- Contradictory requirements
- Untestable requirements
- Missing critical error handling
- Unspecified atomicity requirements
- Security implications not addressed

⚠️ **HIGH**:
- Ambiguous language
- Missing edge case specifications
- Inconsistent terminology
- Vague success criteria

💡 **SUGGESTIONS**:
- Additional examples would help
- Consider these additional edge cases
- Clarify this ambiguous section

---

## Review Response Format

Use this structure:

```markdown
# Review Response: [Topic]

**Reviewer**: GPT-5 Codex | GPT-5  
**Date**: YYYY-MM-DD  
**Review Type**: Code | Spec | Documentation  

## Summary

[Overall assessment: ✅ Approved / ⚠️ Issues Found / ❌ Major Problems]

[One paragraph summarizing findings]

## Issues Found

### 🚨 CRITICAL (MUST fix before merge)

1. **[Issue Title]**
   - **Location**: [file:line or section]
   - **Problem**: [What's wrong]
   - **Impact**: [Why it's critical]
   - **Fix**: [How to fix it]
   - **Test**: [How to verify fixed]

### ⚠️ HIGH (Should fix)

[Same format]

### 💡 SUGGESTIONS (Consider)

[Same format]

## Contract Verification

[For code reviews]

| Contract | Satisfied? | Test Exists? | Notes |
|----------|------------|--------------|-------|
| MUST create file | ✅ Yes | ✅ Yes | test_create_file |
| MUST NOT overwrite | ⚠️ Partial | ❌ No | Missing test for edge case |
| INVARIANT atomic | ❌ No | ❌ No | Non-atomic on error |

## Recommendations

### Immediate Actions

1. [What must be done now]
2. [What must be done now]

### Follow-up

1. [What should be done next]
2. [What should be done later]

## Approval Status

- [ ] ✅ **APPROVED** - Ready to merge
- [ ] ⚠️ **APPROVED WITH COMMENTS** - Can merge, but address suggestions in follow-up
- [ ] 🔄 **REQUEST CHANGES** - Must fix issues before merge
- [ ] ❌ **REJECTED** - Major problems, significant rework needed
```

---

## Review Checklist

### For Code Reviews

#### Correctness
- [ ] Implements spec correctly
- [ ] All contract tests pass
- [ ] Edge cases handled
- [ ] Error conditions handled
- [ ] No obvious bugs

#### Quality
- [ ] Well-documented (docstrings, comments)
- [ ] Type hints present
- [ ] Clear variable names
- [ ] No code duplication
- [ ] Follows project standards

#### Testing
- [ ] Contract test per MUST/MUST NOT/INVARIANT
- [ ] Unit tests for components
- [ ] Integration tests for workflows
- [ ] Edge cases tested
- [ ] Error paths tested

#### Safety
- [ ] No security vulnerabilities
- [ ] No data loss scenarios
- [ ] Resource cleanup handled
- [ ] Thread-safety considered
- [ ] Atomic operations where required

### For Spec Reviews

#### Completeness
- [ ] Behavioral contracts defined (MUST/MUST NOT/INVARIANTS)
- [ ] Success criteria clear
- [ ] Failure modes identified
- [ ] Edge cases specified
- [ ] Error handling specified

#### Clarity
- [ ] Unambiguous language
- [ ] Consistent terminology
- [ ] Examples provided
- [ ] Assumptions stated

#### Testability
- [ ] All behaviors testable
- [ ] Verification methods clear
- [ ] Test scenarios provided

---

## Common Patterns to Check

### Storage Operations

For file storage backend, always verify:

1. **Path Safety**:
   - [ ] No path traversal vulnerabilities (`../` handling)
   - [ ] Paths normalized/resolved
   - [ ] Base path restrictions enforced

2. **Atomicity**:
   - [ ] Operations are atomic (all-or-nothing)
   - [ ] Partial states cleaned up on error
   - [ ] No orphaned files/locks

3. **Idempotency**:
   - [ ] Retry-safe where appropriate
   - [ ] Duplicate operations handled
   - [ ] State remains consistent

4. **Error Handling**:
   - [ ] File not found handled
   - [ ] Permission denied handled
   - [ ] Disk full handled
   - [ ] Concurrent modification handled

5. **Resource Management**:
   - [ ] Files closed properly
   - [ ] Locks released
   - [ ] Temp files cleaned up
   - [ ] No file descriptor leaks

---

## Example Reviews

### Example 1: Missing Contract Test

```markdown
### ⚠️ HIGH: Missing contract test for MUST NOT

**Location**: tests/contracts/test_create_contract.py
**Problem**: Spec states "MUST NOT overwrite existing file", but no test verifies this
**Impact**: Implementation could violate contract without detection
**Fix**: Add test:
```python
def test_must_not_overwrite_existing_file():
    """MUST NOT: Overwrite existing file without explicit flag"""
    storage = LocalStorage(base_path)
    storage.create("test.txt", "content1")
    
    with pytest.raises(FileExistsError):
        storage.create("test.txt", "content2")
    
    # Verify original content unchanged
    assert storage.view("test.txt")['content'] == "content1"
```
**Test**: Run `pytest tests/contracts/ -v` and verify test passes
```

### Example 2: Non-Atomic Operation

```markdown
### 🚨 CRITICAL: Non-atomic operation violates INVARIANT

**Location**: src/storage/local_storage.py:145-167
**Problem**: `rename()` operation not atomic - creates new file before deleting old
**Impact**: On error/interrupt, both old and new files exist (violates INVARIANT: "No orphaned files")
**Fix**: Use atomic `os.rename()` instead of copy+delete:
```python
def rename(self, old_path: str, new_path: str) -> None:
    """Atomically rename file"""
    old_full = self.base_path / old_path
    new_full = self.base_path / new_path
    
    # os.rename is atomic on same filesystem
    os.rename(old_full, new_full)
```
**Test**: Add test that interrupts mid-operation and verifies no orphans
```

### Example 3: Unclear Spec

```markdown
### ⚠️ HIGH: Ambiguous specification

**Location**: specs/file_operations_contract.md, Section 3.2
**Problem**: "Files must be created atomically" - what does atomic mean here?
**Impact**: Implementer might interpret differently, leading to inconsistent behavior
**Fix**: Clarify with specific examples:

```markdown
MUST create files atomically:
- Atomic means: File appears fully written or not at all
- Implementation: Write to temp file, then atomic rename
- Test: Verify interrupted write doesn't leave partial file
- Example: No 0-byte files, no partial content visible
```

**Test**: Can you write a test that verifies the spec?
```

---

## When to Approve vs Request Changes

### ✅ APPROVE
- All critical contracts satisfied
- All tests passing
- Code quality good
- Documentation complete
- Only minor suggestions

### ⚠️ APPROVE WITH COMMENTS
- All critical contracts satisfied
- Tests passing
- Some improvements suggested but not blocking
- Documentation adequate
- Can be addressed in follow-up

### 🔄 REQUEST CHANGES
- Contract violations found
- Missing critical tests
- Significant quality issues
- Incomplete error handling
- Must fix before merge

### ❌ REJECT
- Multiple critical contract violations
- Fundamental design flaws
- Security vulnerabilities
- Spec contradicts itself
- Needs major rework

---

## Remember

- **Be specific**: Point to exact locations, provide exact fixes
- **Be constructive**: Suggest improvements, don't just criticize
- **Be thorough**: Check all contracts, all edge cases
- **Be fair**: Approve when quality is sufficient, even if not perfect
- **Be clear**: Use examples to illustrate issues

Your goal: **Ensure quality while enabling progress.**

---

## Quick Reference

**Code review focus**:
1. Contract conformance (most important)
2. Test coverage
3. Error handling
4. Code quality

**Spec review focus**:
1. Clear behavioral contracts
2. Testability
3. Completeness
4. Clarity

**Always ask**:
- Can this be tested?
- Are edge cases handled?
- What happens on error?
- Does this match the spec?

---

**Questions about review process?** Check docs/REVIEW_CHECKLIST.md or flag unclear areas in your review response.
