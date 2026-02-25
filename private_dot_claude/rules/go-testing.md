# Go Testing Standards

## Assertion Libraries

**Always use testify assert/require instead of manual t.Fatal/t.Fatalf checks.**

### Pattern: require for preconditions (stops test)

Use `require` when a failure means the test cannot continue:

```go
// Setup failures
require.NoError(t, err, "Failed to start server")
require.NotNil(t, obj, "Expected non-nil object")

// Preconditions that must be true
require.True(t, serverReady, "Server must be ready")
require.Equal(t, expected, actual, "Setup values must match")
```

### Pattern: assert for test assertions (continues test)

Use `assert` for the actual test conditions where you want to see all failures:

```go
assert.Equal(t, expected, actual, "Value mismatch")
assert.Contains(t, haystack, needle, "Should contain value")
assert.NoError(t, err, "Operation should succeed")
assert.Len(t, slice, 5, "Should have 5 items")
```

### Anti-patterns to avoid

```go
// ❌ DON'T: Manual error checks
if err != nil {
    t.Fatalf("Failed: %v", err)
}

// ✅ DO: Use require/assert
require.NoError(t, err, "Failed")

// ❌ DON'T: Manual value comparisons
if result != expected {
    t.Errorf("Got %v, want %v", result, expected)
}

// ✅ DO: Use assert
assert.Equal(t, expected, result, "Result mismatch")
```

### Import pattern

Always import both when writing tests:

```go
import (
    "testing"

    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)
```

### When to use each

- **require**: Setup, preconditions, file I/O, parsing—anything where failure means "stop now"
- **assert**: Actual test conditions where you want to see multiple failures in one run
