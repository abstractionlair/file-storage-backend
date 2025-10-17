# Code Standards

**Purpose**: Coding standards and style guide for file-storage-backend.

---

## Language & Version

**Python 3.10+**

Use modern Python features where appropriate:
- Type hints (required)
- Pattern matching (where it improves clarity)
- Dataclasses (for structured data)
- Context managers (for resource management)

---

## Style Guide

### PEP 8 Compliance

Follow [PEP 8](https://pep8.org/) with these specifications:

**Line length**: 88 characters (Black default)  
**Indentation**: 4 spaces (never tabs)  
**Imports**: Organized per PEP 8 order  
**Naming**: See section below

### Automated Formatting

Use **Black** for formatting:
```bash
black src/ tests/
```

No configuration needed - accept Black defaults.

### Import Organization

```python
# Standard library imports
import os
import sys
from pathlib import Path
from typing import Union, Optional

# Third-party imports
import pytest

# Local imports
from storage.interface import StorageBackend
from storage.local_storage import LocalStorage
```

Order:
1. Standard library
2. Third-party packages
3. Local modules

Within each group: alphabetical order.

---

## Naming Conventions

### Files and Directories

- **Files**: `snake_case.py`
- **Directories**: `snake_case/`
- **Test files**: `test_[module].py`

Examples:
- `local_storage.py` ✅
- `LocalStorage.py` ❌
- `test_local_storage.py` ✅

### Variables and Functions

- **Functions**: `snake_case`
- **Variables**: `snake_case`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private**: `_leading_underscore`

```python
# Good
def create_file(file_path: str) -> None:
    max_retries = 3
    BASE_PATH = "/storage"
    _internal_buffer = []

# Bad
def CreateFile(filePath: str) -> None:
    MaxRetries = 3
    basePath = "/storage"
```

### Classes

- **Classes**: `PascalCase`
- **Private classes**: `_PascalCase`

```python
class LocalStorage:  # ✅
    pass

class local_storage:  # ❌
    pass
```

### Type Variables

```python
from typing import TypeVar

T = TypeVar('T')  # ✅
PathType = TypeVar('PathType')  # ✅
```

---

## Type Hints

**Required for all functions and methods.**

### Basic Types

```python
def create_file(
    path: str,
    content: str | bytes,  # Python 3.10+ union syntax
    encoding: str = "utf-8"
) -> None:
    ...

def read_file(path: str) -> str:
    ...

def get_size(path: str) -> int:
    ...
```

### Complex Types

```python
from typing import Optional, Union, List, Dict, Any
from pathlib import Path

def process_files(
    paths: list[str],  # Python 3.10+ syntax
    options: dict[str, Any]
) -> list[Path]:
    ...

def find_file(name: str) -> Optional[Path]:
    # Returns Path or None
    ...
```

### Return Types

Always specify, even for None:

```python
def delete_file(path: str) -> None:  # ✅
    ...

def delete_file(path: str):  # ❌
    ...
```

---

## Documentation

### Module Docstrings

Every module has a docstring:

```python
"""
Local filesystem storage backend.

Implements the StorageBackend interface for local file operations.
Provides 6 core operations: view, create, str_replace, insert, delete, rename.

Thread-safe for single process, but NOT multi-process safe.
"""
```

### Function Docstrings

Use Google-style docstrings:

```python
def create_file(path: str, content: str | bytes) -> None:
    """
    Create a new file with given content.
    
    Args:
        path: Relative path for the new file
        content: File content as string or bytes
        
    Raises:
        FileExistsError: If file already exists at path
        ValueError: If path is invalid or outside base_path
        PermissionError: If cannot create file due to permissions
        
    Example:
        >>> storage = LocalStorage("/data")
        >>> storage.create("test.txt", "Hello World")
    """
```

### Class Docstrings

```python
class LocalStorage:
    """
    Local filesystem implementation of storage backend.
    
    Provides file operations scoped to a base directory. All paths
    are relative to base_path and cannot escape it.
    
    Attributes:
        base_path: Root directory for all operations
        
    Thread Safety:
        Safe for single process, multiple threads.
        NOT safe for multiple processes writing simultaneously.
    """
```

### Inline Comments

Use sparingly. Good code is self-documenting.

```python
# Good - explains WHY
# Check for path traversal attack
if ".." in normalized_path:
    raise ValueError("Path traversal not allowed")

# Bad - explains WHAT (obvious from code)
# Set the path variable
path = user_input
```

---

## Error Handling

### Use Specific Exceptions

```python
# Good
if not path.exists():
    raise FileNotFoundError(f"File not found: {path}")

# Bad
if not path.exists():
    raise Exception("Error")
```

### Include Context in Error Messages

```python
# Good
raise ValueError(
    f"Path '{path}' is outside base directory '{self.base_path}'"
)

# Bad
raise ValueError("Invalid path")
```

### Don't Catch Too Broadly

```python
# Good
try:
    content = path.read_text()
except FileNotFoundError:
    # Handle specific error
    ...

# Bad
try:
    content = path.read_text()
except Exception:  # Too broad
    ...
```

### Clean Up Resources

Use context managers:

```python
# Good
with open(path, 'r') as f:
    content = f.read()

# Bad
f = open(path, 'r')
content = f.read()
f.close()  # Might not execute if exception
```

---

## Code Organization

### File Structure

```python
"""Module docstring"""

# Imports (organized)

# Constants
DEFAULT_ENCODING = "utf-8"
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB

# Type definitions
PathLike = str | Path

# Classes

# Functions

# Main execution (if applicable)
if __name__ == "__main__":
    ...
```

### Class Structure

```python
class LocalStorage:
    """Docstring"""
    
    # Class variables
    DEFAULT_ENCODING = "utf-8"
    
    def __init__(self, base_path: str) -> None:
        """Constructor"""
        ...
    
    # Public methods
    def create_file(self, path: str, content: str) -> None:
        """Public method"""
        ...
    
    # Private methods
    def _validate_path(self, path: str) -> Path:
        """Private helper"""
        ...
    
    # Magic methods last
    def __repr__(self) -> str:
        return f"LocalStorage(base_path={self.base_path})"
```

---

## Best Practices

### Explicit is Better Than Implicit

```python
# Good
def process_file(path: str, encoding: str = "utf-8") -> str:
    ...

# Bad (what's the default?)
def process_file(path: str, encoding=None) -> str:
    if encoding is None:
        encoding = "utf-8"
    ...
```

### Small Functions

Keep functions focused:

```python
# Good - does one thing
def validate_path(path: str) -> Path:
    """Validate and normalize path."""
    ...

def check_file_exists(path: Path) -> bool:
    """Check if file exists."""
    ...

# Bad - does too much
def validate_and_check_path(path: str) -> tuple[Path, bool]:
    """Validate path and check if exists."""
    ...
```

### Avoid Magic Numbers

```python
# Good
MAX_RETRIES = 3
BUFFER_SIZE = 8192

if retries > MAX_RETRIES:
    ...

# Bad
if retries > 3:
    ...
```

### Use Enums for Fixed Sets

```python
from enum import Enum

class FileType(Enum):
    TEXT = "text"
    BINARY = "binary"
    JSON = "json"

# Usage
def read_file(path: str, file_type: FileType) -> str | bytes:
    ...
```

---

## Performance Considerations

### Path Operations

Use `pathlib.Path` for path operations:

```python
from pathlib import Path

# Good
path = Path(base_path) / relative_path
if path.exists():
    ...

# Bad
import os
path = os.path.join(base_path, relative_path)
if os.path.exists(path):
    ...
```

### File I/O

For large files, read in chunks:

```python
# Good
def read_large_file(path: Path, chunk_size: int = 8192) -> Iterator[bytes]:
    with open(path, 'rb') as f:
        while chunk := f.read(chunk_size):
            yield chunk

# Bad - loads entire file
def read_large_file(path: Path) -> bytes:
    return path.read_bytes()
```

### String Operations

```python
# Good - single pass
content = content.replace(old_str, new_str)

# Bad - multiple passes
for old, new in replacements:
    content = content.replace(old, new)
```

---

## Security

### Path Traversal Prevention

Always validate paths:

```python
def validate_path(self, path: str) -> Path:
    """Prevent path traversal attacks."""
    resolved = (self.base_path / path).resolve()
    
    # Ensure path is within base_path
    if not resolved.is_relative_to(self.base_path):
        raise ValueError(f"Path escapes base directory: {path}")
    
    return resolved
```

### Input Validation

```python
def create_file(self, path: str, content: str | bytes) -> None:
    """Create file with validation."""
    # Validate path
    if not path or path.isspace():
        raise ValueError("Path cannot be empty")
    
    # Validate content
    if isinstance(content, str) and len(content) > MAX_CONTENT_SIZE:
        raise ValueError("Content exceeds maximum size")
    
    ...
```

---

## Testing Helpers

### Use Fixtures

```python
# conftest.py
import pytest
from pathlib import Path

@pytest.fixture
def temp_storage(tmp_path):
    """Provide temporary storage instance."""
    return LocalStorage(tmp_path)

# test file
def test_create_file(temp_storage):
    temp_storage.create("test.txt", "content")
    assert (temp_storage.base_path / "test.txt").exists()
```

### Parametrize Tests

```python
@pytest.mark.parametrize("content", [
    "simple text",
    "unicode: 你好",
    "emoji: 🎉",
    b"binary content",
])
def test_create_with_various_content(temp_storage, content):
    temp_storage.create("test.txt", content)
    ...
```

---

## Quick Reference

**Style**: Black (88 char lines)  
**Types**: Required for all functions  
**Docstrings**: Google style, required  
**Names**: `snake_case` functions, `PascalCase` classes  
**Errors**: Specific exceptions with context  
**Paths**: Use `pathlib.Path`  
**Security**: Validate all input, prevent path traversal  

**When in doubt**: Be explicit, be clear, be safe.
