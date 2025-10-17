# Specifications

This directory contains all feature specifications and behavioral contracts.

## Directory Structure

```
specs/
├── todo/      # Specs that need to be written
├── doing/     # Specs in progress (being written or reviewed)
└── done/      # Completed specs (approved and implemented)
```

## Workflow

Specs move through directories as they progress:

```
todo/ → doing/ → done/
```

### todo/

Specs that need to be written. These are placeholders or stubs.

**Example**:
```markdown
# File Operations Contract

TODO: Write behavioral contracts for the 6 file operations.

Needs:
- MUST/MUST NOT/INVARIANTS for each operation
- Test scenarios
- Error handling specifications
```

### doing/

Specs actively being developed or reviewed.

**Stages**:
1. **Draft** - Being written in Claude Projects
2. **Review** - Awaiting GPT-5 review
3. **Revision** - Incorporating feedback

**Move to done/** when: Spec approved and ready for implementation

### done/

Completed specs that have been:
- ✅ Written and reviewed
- ✅ Approved by GPT-5
- ✅ Ready for implementation (or already implemented)

These are the source of truth for implementation and tests.

## Spec Template

Each spec should include:

```markdown
# [Feature Name]

**Status**: Draft | Review | Approved  
**Created**: YYYY-MM-DD  
**Reviewer**: GPT-5 | Codex  
**Implementation**: Pending | In Progress | Complete

## Purpose

[Why this feature exists]

## Behavioral Contracts

### MUST

- List required behaviors
- Each should be testable
- Use active, precise language

### MUST NOT

- List forbidden behaviors
- Each should be detectable
- Prevents anti-patterns

### INVARIANTS

- List properties that must always hold
- Verifiable programmatically
- Survive across operations

## Test Scenarios

[Concrete examples of how to test]

## Edge Cases

[Boundary conditions, error states, race conditions]

## Success Criteria

[How do we know implementation is correct?]
```

## Moving Specs

When moving a spec between directories:

```bash
# Moving to 'doing' (started work)
git mv specs/todo/feature_name.md specs/doing/feature_name.md

# Moving to 'done' (completed)
git mv specs/doing/feature_name.md specs/done/feature_name.md
```

Git preserves history even when files move.

## Current Status

Check each directory to see what's in progress:

```bash
ls specs/todo/      # What needs writing
ls specs/doing/     # What's in progress
ls specs/done/      # What's complete
```

Or use the GitHub interface to browse.
