# Quick Reference: Testing Workflow Locally

## TL;DR

```bash
# Full end-to-end test (recommended)
releasing/test-e2e.sh v1.0.0

# Or step by step:
releasing/test-workflow.sh v1.0.0        # Simulate workflow
releasing/validate-formula.sh Formula/elm-wrap.rb.test  # Validate output
rm -f elm-wrap-macos-* Formula/elm-wrap.rb.test  # Cleanup
```

## Files Created

| File | Purpose |
|------|---------|
| `test-e2e.sh` | **Complete end-to-end test** - Run this for full validation |
| `test-workflow.sh` | Simulates the GitHub Actions workflow locally |
| `validate-formula.sh` | Validates the generated Homebrew formula |
| `TESTING.md` | Complete testing documentation |

## What Was Fixed

**Problem**: Workflow failed due to heredoc (`<<EOF`) syntax conflicts with Ruby interpolation `#{}`.

**Solution**: Replaced heredoc with `printf` statements for reliable variable substitution.

**Additional improvements**:
- Added `-f` flag to curl for better error detection
- Added explicit error messages for failed downloads
- Created comprehensive local testing suite

## Testing Before Push

```bash
# Always test locally before pushing
releasing/test-e2e.sh v1.0.1
```

## When to Use Each Script

- **`test-e2e.sh`** - Use this for complete validation before committing
- **`test-workflow.sh`** - Use to debug specific workflow logic
- **`validate-formula.sh`** - Use to check formula syntax/structure only

## Workflow Trigger

The workflow runs automatically when:
1. You create a new release in `dsimunic/elm-wrap`
2. The release workflow dispatches the `elm-wrap-release` event
3. This repository receives the event and updates `Formula/elm-wrap.rb`

Manual trigger (requires GitHub CLI):
```bash
gh api repos/dsimunic/homebrew-elm-wrap/dispatches \
  -X POST \
  -f event_type=elm-wrap-release \
  -f client_payload[version]=v1.0.0
```

## Troubleshooting

| Error | Solution |
|-------|----------|
| "Failed to download AMD64 binary" | Ensure release has both ARM64 and AMD64 binaries |
| "Formula validation failed" | Run `./validate-formula.sh` to see specific errors |
| "Workflow simulation failed" | Check that the release tag exists on GitHub |
