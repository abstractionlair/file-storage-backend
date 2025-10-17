# Testing Guidelines

**Purpose**: Comprehensive testing strategy for file-storage-backend.

---

## Testing Philosophy

### Three-Layer Testing

1. **Contract Tests** - Verify behavioral contracts (MUST/MUST NOT/INVARIANTS)
2. **Unit Tests** - Test individual components in isolation
3. **Integration Tests** - Test complete workflows end-to-end

Each layer serves a different purpose and all are required.

---

## Contract Tests

### Purpose

Contract tests verify the behavioral contract from the spec. They prove that implementation satisfies all requirements.

### Location

`tests/contracts/test_[feature]_contract.py`

### Structure

```python
"""
Contract tests for [feature name].

These tests directly verify the MUST/MUST NOT/INVARIANTS from:
specs/doing/[feature].md (or specs/done/ after completion)

Each test docstring quotes the exact requirement from the spec.
"""

import pytest
from storage.local_storage import LocalStorage

def test_must_[behavior_description]():
    """
    MUST: [Exact text from spec's MUST section]
    
    Spec reference: specs/doing/[feature].md, section "MUST"
    """
    # Test implementation
    pass

def test_must_not_[behavior_description]():
    """
    MUST NOT: [Exact text from spec's MUST NOT section]
    
    Spec reference: specs/doing/[feature].md, section "MUST NOT"
    """
    # Test implementation
    # Should verify that forbidden behavior raises appropriate error
    pass

def test_invariant_[property_description]():
    """
    INVARIANT: [Exact text from spec's INVARIANTS section]
    
    Spec reference: specs/doing/[feature].md, section "INVARIANTS"
    """
    # Test implementation
    # Should verify property holds under all tested conditions
    pass
```

### Requirements

- ✅ Every MUST has a test
- ✅ Every MUST NOT has a test
- ✅ Every INVARIANT has a test
- ✅ Test docstrings quote spec exactly
- ✅ Tests are independent (can run in any order)
- ✅ Tests use clear, descriptive names

### Example

```python
def test_must_create_file_at_specified_path():
    """
    MUST: Create file at specified path with given content.
    
    Spec reference: specs/doing/file_operations.md
    """
    storage = LocalStorage("/tmp/test")
    storage.create("test.txt", "Hello World")
    
    # Verify file exists at exact path
    assert (Path("/tmp/test") / "test.txt").exists()
    
    # Verify content matches
    content = (Path("/tmp/test") / "test.txt").read_text()
    assert content == "Hello World"

def test_must_not_overwrite_existing_file():
    """
    MUST NOT: Overwrite existing file without explicit flag.
    
    Spec reference: specs/doing/file_operations.md
    """
    storage = LocalStorage("/tmp/test")
    storage.create("test.txt", "First")
    
    # Attempting to create again should raise FileExistsError
    with pytest.raises(FileExistsError):
        storage.create("test.txt", "Second")
    
    # Verify original content unchanged
    content = (Path("/tmp/test") / "test.txt").read_text()
    assert content == "First"

def test_invariant_operations_are_atomic():
    """
    INVARIANT: All operations are atomic (all-or-nothing).
    
    If operation fails partway through, no artifacts are left behind.
    
    Spec reference: specs/doing/file_operations.md
    """
    storage = LocalStorage("/tmp/test")
    
    # Attempt operation that will fail
    # (e.g., insufficient permissions, disk full)
    try:
        storage.create("test.txt", "x" * 1_000_000_000)  # Too large
    except Exception:
        pass
    
    # Verify no partial file exists
    assert not (Path("/tmp/test") / "test.txt").exists()
```

---

## Unit Tests

### Purpose

Test individual components, methods, and functions in isolation. Cover implementation details and edge cases not covered by contract tests.

### Location

`tests/unit/test_[module].py`

### Structure

```python
"""
Unit tests for [module name].

Tests internal implementation details, edge cases, and helper methods.
Focused on testing components in isolation.
"""

import pytest
from storage.local_storage import LocalStorage, _validate_path

class TestPathValidation:
    """Tests for path validation logic."""
    
    def test_rejects_absolute_paths(self):
        """Absolute paths should be rejected."""
        storage = LocalStorage("/base")
        with pytest.raises(ValueError, match="absolute"):
            storage._validate_path("/etc/passwd")
    
    def test_rejects_path_traversal(self):
        """Paths with .. should be rejected."""
        storage = LocalStorage("/base")
        with pytest.raises(ValueError, match="traversal"):
            storage._validate_path("../etc/passwd")
    
    def test_normalizes_paths(self):
        """Paths should be normalized."""
        storage = LocalStorage("/base")
        path = storage._validate_path("./foo//bar/../baz")
        assert str(path) == "/base/foo/baz"

class TestContentHandling:
    """Tests for content encoding and processing."""
    
    def test_handles_unicode(self):
        """Unicode content should be handled correctly."""
        storage = LocalStorage("/tmp/test")
        storage.create("test.txt", "Hello 世界 🌍")
        content = storage.view("test.txt")
        assert content == "Hello 世界 🌍"
    
    def test_handles_binary(self):
        """Binary content should be preserved exactly."""
        storage = LocalStorage("/tmp/test")
        binary_data = bytes([0, 1, 2, 255])
        storage.create("test.bin", binary_data)
        content = storage.view("test.bin")
        assert content == binary_data
```

### Requirements

- ✅ Test edge cases
- ✅ Test error conditions
- ✅ Test boundary values
- ✅ Test helper/private methods
- ✅ Use descriptive test names
- ✅ Group related tests in classes

### Coverage Target

**100% coverage of new code.**

Check coverage:
```bash
pytest --cov=src --cov-report=term-missing
```

---

## Integration Tests

### Purpose

Test complete workflows end-to-end with all components interacting. Verify system behavior in realistic scenarios.

### Location

`tests/integration/test_[feature]_integration.py`

### Structure

```python
"""
Integration tests for [feature name].

Tests complete workflows with all components working together.
Uses realistic scenarios.
"""

import pytest
from storage.local_storage import LocalStorage

def test_complete_file_lifecycle():
    """Test creating, reading, updating, and deleting a file."""
    storage = LocalStorage("/tmp/test")
    
    # Create
    storage.create("document.txt", "Initial content")
    
    # Read
    content = storage.view("document.txt")
    assert content == "Initial content"
    
    # Update
    storage.str_replace("document.txt", "Initial", "Updated")
    content = storage.view("document.txt")
    assert content == "Updated content"
    
    # Delete
    storage.delete("document.txt")
    with pytest.raises(FileNotFoundError):
        storage.view("document.txt")

def test_multi_file_operations():
    """Test working with multiple files simultaneously."""
    storage = LocalStorage("/tmp/test")
    
    # Create multiple files
    for i in range(10):
        storage.create(f"file_{i}.txt", f"Content {i}")
    
    # Verify all exist
    for i in range(10):
        content = storage.view(f"file_{i}.txt")
        assert content == f"Content {i}"
    
    # Rename some
    storage.rename("file_0.txt", "renamed.txt")
    assert storage.view("renamed.txt") == "Content 0"
    
    # Delete some
    for i in range(5):
        storage.delete(f"file_{i+1}.txt")
    
    # Verify correct files remain
    remaining = storage.view("")  # List directory
    assert "renamed.txt" in remaining
    assert len([f for f in remaining if f.startswith("file_")]) == 5

def test_error_recovery():
    """Test that system recovers properly from errors."""
    storage = LocalStorage("/tmp/test")
    
    # Create file
    storage.create("test.txt", "content")
    
    # Attempt invalid operation
    try:
        storage.str_replace("test.txt", "nonexistent", "replacement")
    except ValueError:
        pass  # Expected
    
    # System should still be operational
    content = storage.view("test.txt")
    assert content == "content"  # Unchanged
    
    # Can perform other operations
    storage.create("another.txt", "more content")
    assert storage.view("another.txt") == "more content"
```

### Requirements

- ✅ Test realistic workflows
- ✅ Test multiple components together
- ✅ Test error recovery
- ✅ Test concurrent operations (if applicable)
- ✅ Test system boundaries

---

## Test Fixtures

### Shared Fixtures

Create in `tests/conftest.py`:

```python
import pytest
import tempfile
import shutil
from pathlib import Path
from storage.local_storage import LocalStorage

@pytest.fixture
def temp_dir():
    """Provide a temporary directory, cleaned up after test."""
    temp_path = Path(tempfile.mkdtemp())
    yield temp_path
    shutil.rmtree(temp_path)

@pytest.fixture
def storage(temp_dir):
    """Provide a LocalStorage instance with temp directory."""
    return LocalStorage(str(temp_dir))

@pytest.fixture
def storage_with_files(storage):
    """Provide storage with some pre-created files."""
    storage.create("file1.txt", "Content 1")
    storage.create("file2.txt", "Content 2")
    storage.create("dir/file3.txt", "Content 3")
    return storage
```

### Usage

```python
def test_something(storage):
    """Test using the storage fixture."""
    storage.create("test.txt", "content")
    assert storage.view("test.txt") == "content"

def test_with_existing_files(storage_with_files):
    """Test with pre-populated storage."""
    # Files already exist
    assert storage_with_files.view("file1.txt") == "Content 1"
```

---

## Parameterized Tests

### Use Cases

Test same logic with multiple inputs:

```python
@pytest.mark.parametrize("content,expected", [
    ("simple", "simple"),
    ("unicode: 你好", "unicode: 你好"),
    ("emoji: 🎉", "emoji: 🎉"),
    ("multiline\ncontent", "multiline\ncontent"),
    ("", ""),  # Empty content
])
def test_content_preservation(storage, content, expected):
    """Content should be preserved exactly."""
    storage.create("test.txt", content)
    assert storage.view("test.txt") == expected

@pytest.mark.parametrize("invalid_path", [
    "/absolute/path",
    "../traversal",
    "../../outside",
    "./../trick",
])
def test_rejects_invalid_paths(storage, invalid_path):
    """Invalid paths should be rejected."""
    with pytest.raises(ValueError):
        storage.create(invalid_path, "content")
```

---

## Test Organization

### File Naming

```
tests/
├── conftest.py                    # Shared fixtures
├── contracts/
│   ├── test_create_contract.py
│   ├── test_read_contract.py
│   └── test_delete_contract.py
├── unit/
│   ├── test_local_storage.py
│   ├── test_path_utils.py
│   └── test_validators.py
└── integration/
    ├── test_file_lifecycle.py
    └── test_error_recovery.py
```

### Test Naming

- **Test files**: `test_[module].py`
- **Test functions**: `test_[behavior]`
- **Test classes**: `Test[Component]`

```python
# Good
def test_create_file_in_subdirectory()
def test_rejects_invalid_encoding()
class TestPathValidation

# Bad
def test1()
def test_stuff()
class Tests
```

---

## Running Tests

### All Tests

```bash
pytest
```

### Specific Layer

```bash
pytest tests/contracts/
pytest tests/unit/
pytest tests/integration/
```

### Specific File

```bash
pytest tests/contracts/test_create_contract.py
```

### Specific Test

```bash
pytest tests/contracts/test_create_contract.py::test_must_create_file
```

### With Coverage

```bash
pytest --cov=src --cov-report=html
open htmlcov/index.html
```

### Verbose Output

```bash
pytest -v
```

### Stop on First Failure

```bash
pytest -x
```

---

## Assertions

### Use Descriptive Assertions

```python
# Good - clear what's being tested
assert actual == expected, f"Expected {expected}, got {actual}"

# Better - pytest does this automatically
assert actual == expected

# Good for exceptions
with pytest.raises(ValueError, match="invalid path"):
    storage.create("/absolute", "content")

# Good for checking existence
assert path.exists(), f"Expected file to exist: {path}"
```

### Multiple Assertions

It's okay to have multiple assertions if they're testing related aspects:

```python
def test_file_creation():
    """Test file is created with correct properties."""
    storage.create("test.txt", "content")
    
    path = storage.base_path / "test.txt"
    assert path.exists(), "File should exist"
    assert path.is_file(), "Should be a file, not directory"
    assert path.read_text() == "content", "Content should match"
```

---

## Mocking and Patching

### When to Mock

- External services (network, database)
- System calls that are hard to test
- Time-dependent behavior

### When NOT to Mock

- Internal logic (defeats the purpose of testing)
- Simple operations (just test them)
- Things that are easy to set up for real

### Example

```python
from unittest.mock import patch, Mock

def test_handles_disk_full_error(storage):
    """Test graceful handling of disk full."""
    with patch('pathlib.Path.write_text') as mock_write:
        mock_write.side_effect = OSError("Disk full")
        
        with pytest.raises(OSError, match="Disk full"):
            storage.create("test.txt", "content")
        
        # Verify no partial file left
        assert not (storage.base_path / "test.txt").exists()
```

---

## Test Data

### Keep Test Data Small

```python
# Good
test_content = "Small test content"

# Bad - unnecessarily large
test_content = "x" * 1_000_000
```

### Use Meaningful Test Data

```python
# Good - shows what's being tested
def test_preserves_formatting():
    content = "Line 1\nLine 2\nLine 3"
    storage.create("test.txt", content)
    assert storage.view("test.txt") == content

# Bad - unclear what's being tested
def test_preserves_formatting():
    content = "abc"
    storage.create("test.txt", content)
    assert storage.view("test.txt") == content
```

---

## Test Checklist

Before considering tests complete:

### Contract Tests
- [ ] Every MUST has a test
- [ ] Every MUST NOT has a test
- [ ] Every INVARIANT has a test
- [ ] Test names and docstrings quote spec
- [ ] All contract tests passing

### Unit Tests
- [ ] All public methods tested
- [ ] Edge cases covered
- [ ] Error conditions tested
- [ ] 100% code coverage
- [ ] All unit tests passing

### Integration Tests
- [ ] Realistic workflows tested
- [ ] Multi-component interactions tested
- [ ] Error recovery tested
- [ ] All integration tests passing

### General
- [ ] Tests are independent (no order dependency)
- [ ] No skipped tests (without good reason)
- [ ] No TODO comments
- [ ] Fast execution (< 1 minute for all tests)
- [ ] Clear failure messages

---

## Common Pitfalls

### ❌ Testing Implementation, Not Behavior

```python
# Bad - testing implementation detail
def test_uses_pathlib():
    storage = LocalStorage("/tmp")
    assert isinstance(storage._internal_path, Path)

# Good - testing behavior
def test_creates_file_at_path():
    storage = LocalStorage("/tmp")
    storage.create("test.txt", "content")
    assert Path("/tmp/test.txt").exists()
```

### ❌ Tests That Don't Test Anything

```python
# Bad - doesn't verify anything
def test_create_file():
    storage.create("test.txt", "content")
    # No assertions!

# Good
def test_create_file():
    storage.create("test.txt", "content")
    assert (storage.base_path / "test.txt").exists()
```

### ❌ Order-Dependent Tests

```python
# Bad - depends on test_create running first
def test_create():
    storage.create("test.txt", "content")

def test_read():
    content = storage.view("test.txt")  # Assumes file exists!
    assert content == "content"

# Good - each test is independent
def test_create():
    storage.create("test.txt", "content")
    assert storage.view("test.txt") == "content"

def test_read():
    storage.create("test.txt", "content")  # Set up own data
    content = storage.view("test.txt")
    assert content == "content"
```

---

## Quick Reference

**Contract tests**: One per MUST/MUST NOT/INVARIANT  
**Unit tests**: Components in isolation, 100% coverage  
**Integration tests**: Realistic end-to-end workflows  

**Run all**: `pytest`  
**With coverage**: `pytest --cov=src`  
**Verbose**: `pytest -v`  

**Fixtures**: Use `conftest.py` for shared setup  
**Parametrize**: Test multiple inputs with `@pytest.mark.parametrize`  
**Mock**: Only when necessary (external services, system calls)  

**Key principle**: Tests should verify **behavior**, not **implementation**.
