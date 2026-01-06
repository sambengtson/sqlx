# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

sqlx is a Go library that extends `database/sql` with struct scanning, named parameters, and driver-aware query binding. It wraps standard library types rather than replacing them.

## Common Commands

```bash
# Run all tests
go test ./...

# Run tests with race detector
make test-race

# Run a single test
go test -run TestStructScan

# Lint code
make lint

# Format code
make fmt

# Check for vulnerabilities
make vuln-check

# Update dependencies
make update-dependencies
```

## Architecture

### Wrapper Pattern

All types wrap their `database/sql` counterparts and add:
- `driverName` - for automatic query rebinding
- `unsafe` bool - silently ignore missing struct fields when true
- `Mapper` - struct field reflection/introspection

| sqlx Type | Wraps |
|-----------|-------|
| `DB` | `*sql.DB` |
| `Tx` | `*sql.Tx` |
| `Stmt` | `*sql.Stmt` |
| `Rows` | `*sql.Rows` |
| `Row` | `*sql.Rows` (reimplemented) |
| `Conn` | `*sql.Conn` |

### Key Packages

- **Root package (`sqlx`)** - Core wrapper types and query methods
- **`reflectx/`** - Struct field mapping and introspection with caching
- **`types/`** - Custom SQL types (GzippedText, JSONText, BitBool)

### Bind Variable Formats

The library handles driver-specific parameter binding via `bind.go`:
- `?` (QUESTION) - MySQL, SQLite
- `$1, $2` (DOLLAR) - PostgreSQL
- `:arg1` (NAMED) - Oracle
- `@p1` (AT) - SQL Server, Azure SQL

Use `Rebind()` to convert queries between formats. Register new drivers with `BindDriver()`.

### Named Parameters

Named queries use `:param` syntax and work with structs/maps. Implemented in `named.go` with `NamedQuery()`, `NamedExec()`, and `NamedStmt`.

### Key Interfaces

- `Queryer`, `Execer`, `Binder` - Core query execution
- `Ext` - Union interface used by NamedQuery/NamedExec
- Context variants: `QueryerContext`, `ExecerContext`, `PreparerContext`

## Testing

Tests run against in-memory SQLite. The CI tests across Go 1.18-1.22. Always run `make test-race` before submitting changes.
