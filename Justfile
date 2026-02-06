# Use bash for portability on Unix-like systems
set shell := ["bash", "-cu"]

# Default task when running `just` with no arguments
default: check

# ---- Variables ----
# Adjust these if needed
PY      := "python3"
SRC     := "src tests"
PKG     := "ml_service"

# ---- Quality & CI Tasks ----

# Format code with Ruff (formatter) and Black
fmt:
    ruff format {{SRC}}
    black {{SRC}}

# Lint with Ruff (no fixes)
lint:
    ruff check {{SRC}}

# Lint and auto-fix with Ruff
fix:
    ruff check --fix {{SRC}}

# Type check with mypy (uses your pyproject settings)
typecheck:
    mypy src

# Run tests quietly (matches your pytest -q)
test *args:
    pytest -q {{args}}

# Run the full suite: format check (non-destructive), lint, typecheck, tests
# This is good for CI

check:
    @echo "→ Ruff (format check)"
    ruff format --check {{SRC}}
    @echo "→ Ruff (lint)"
    ruff check {{SRC}}
    @echo "→ Mypy (typecheck)"
    mypy src
    @echo "→ Pytest (tests)"
    pytest -q

# ---- pre-commit helpers ----

# Install pre-commit hooks locally
precommit-install:
    pre-commit install

# Run all pre-commit hooks against all files
precommit-run:
    pre-commit run --all-files

# ---- Local Dev Utilities ----

# Clean common build/test caches
clean:
    rm -rf .pytest_cache .mypy_cache .ruff_cache build dist *.egg-info

# Example: run a module from your package (adjust entrypoint if needed)
run *args:
    {{PY}} -m {{PKG}} {{args}}

