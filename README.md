# File Storage Backend

Thin file storage backend with 6 operations, compatible with Anthropic Memory Tool specification.

## Overview

This provides a pluggable file storage backend that can be used by the memory-graph system. It implements 6 core operations that match Anthropic's Memory Tool spec, allowing future migration to their system while maintaining a local implementation today.

## Core Operations

1. **view(path)** - Read file content or list directory
2. **create(path, content)** - Create new file
3. **str_replace(path, old, new)** - Replace text in file
4. **insert(path, line, text)** - Insert text at line number
5. **delete(path)** - Remove file
6. **rename(old, new)** - Move/rename file

## Architecture

```
Storage Interface (abstract)
       ↓
Local Implementation (filesystem)
       ↓
Future: Anthropic Memory Tool adapter
```

## Project Structure

```
file-storage-backend/
├── src/storage/          # Implementation
├── tests/                # Test suites
│   ├── contracts/        # Behavioral contract tests
│   ├── unit/             # Component tests
│   └── integration/      # System tests
├── specs/                # Feature specifications
└── docs/                 # Documentation
```

## Development Workflow

This project uses a contract-driven development workflow:

1. **Specs written in Claude Projects** (conversational, iterative)
2. **Specs reviewed by GPT-5** (methodology validation)
3. **Implementation by Claude Code** (from complete specs)
4. **Code reviewed by Codex** (contract conformance)
5. **PR review by human** (evidence-based, not code-based)

See **CLAUDE.md** for Claude Code instructions.  
See **AGENTS.md** for Codex review instructions.

## Installation

```bash
# Clone
git clone https://github.com/abstractionlair/file-storage-backend.git
cd file-storage-backend

# Install (Python 3.10+)
pip install -e .

# Run tests
pytest tests/ -v
```

## Usage

```python
from storage import LocalStorage

# Initialize
storage = LocalStorage(base_path="/path/to/storage")

# Create file
storage.create("notes.md", "# My Notes\n\nContent here")

# View file
result = storage.view("notes.md")
print(result['content'])

# Update file
storage.str_replace("notes.md", "Content here", "Updated content")

# Rename
storage.rename("notes.md", "archive/old_notes.md")

# Delete
storage.delete("archive/old_notes.md")
```

## Design Principles

1. **Simple**: 6 operations, minimal interface
2. **Pluggable**: Easy to swap implementations
3. **Safe**: Atomic operations, proper error handling
4. **Compatible**: Matches Anthropic Memory Tool spec
5. **Testable**: Contract-driven, comprehensive tests

## Status

**Phase**: Initial setup  
**Progress**: Repository scaffolding, instruction files created  
**Next**: Create first spec (file operations contract)

## Contributing

We use a specific workflow for this project:

- **Spec development**: Claude Projects (conversational)
- **Implementation**: Claude Code (from specs)
- **Review**: Codex via MCP (automated)
- **Approval**: PR-based (evidence report review)

See CLAUDE.md and AGENTS.md for details.

## License

MIT
Start
