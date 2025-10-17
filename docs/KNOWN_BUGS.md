# Known Bugs

**Purpose**: Track known bugs to prevent regression and inform future development.

---

## Active Bugs

**None currently.**

---

## Resolved Bugs

**None yet.**

---

## Bug Entry Format

When a bug is discovered, add entry here:

```markdown
### Bug #[number]: [Brief Description]

**Status**: Active | Fixed | Wontfix  
**Severity**: Critical | High | Medium | Low  
**Discovered**: YYYY-MM-DD  
**Fixed**: YYYY-MM-DD (if applicable)

**Description**:
[Detailed description of the bug]

**Steps to Reproduce**:
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior**:
[What should happen]

**Actual Behavior**:
[What actually happens]

**Workaround** (if any):
[Temporary solution]

**Fix** (if resolved):
[How it was fixed, reference to commit/PR]

**Related**:
- Issue #X
- PR #Y
- Commit abc123
```

---

## Examples

### Bug #1: Path Traversal in Rename Operation

**Status**: Fixed  
**Severity**: Critical  
**Discovered**: 2025-10-15  
**Fixed**: 2025-10-16

**Description**:
The `rename()` operation did not properly validate the destination path, allowing path traversal attacks. Files could be moved outside the base directory.

**Steps to Reproduce**:
1. Create storage: `storage = LocalStorage("/base")`
2. Create file: `storage.create("test.txt", "content")`
3. Rename with traversal: `storage.rename("test.txt", "../outside.txt")`
4. File ends up at `/outside.txt` instead of being rejected

**Expected Behavior**:
Should raise `ValueError` for paths outside base directory.

**Actual Behavior**:
File is moved to `/outside.txt` without error.

**Fix**:
Added path validation to `rename()` method. Both source and destination paths now validated to ensure they're within base directory. Added contract test to prevent regression.

**Related**:
- PR #42
- Commit 7d8f9a2
- Test: `tests/contracts/test_rename_contract.py::test_must_not_traverse_paths`

---

## Regression Prevention

When a bug is fixed:

1. **Add contract test** to prevent regression
2. **Update this document** with details
3. **Reference in commit message**
4. **Leave in "Resolved" section** (don't delete - historical record)

## Questions?

If unsure whether something is a bug or expected behavior, ask the user or check the spec.
