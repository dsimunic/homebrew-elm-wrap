# Testing the GitHub Actions Workflow Locally

This guide explains how to test the `update-elm-wrap.yml` workflow locally before pushing changes.

## Prerequisites

- `curl` (for downloading release artifacts)
- `shasum` (for computing checksums)
- `brew` (optional, for formula validation)
- `ruby` (optional, for syntax validation)

## Quick Test

To test the workflow logic with a specific release version:

```bash
releasing/test-workflow.sh v1.0.1
```

Replace `v1.0.1` with any valid release tag from https://github.com/dsimunic/elm-wrap/releases

**Note**: The release must have both `elm-wrap-macos-arm64` and `elm-wrap-macos-amd64` binaries attached.

## What the Test Does

1. **Validates version parsing** - Strips the `v` prefix correctly
2. **Downloads release artifacts** - Fetches both ARM64 and AMD64 binaries
3. **Computes checksums** - Generates SHA256 hashes for both files
4. **Generates formula** - Creates the Homebrew formula file with proper substitutions
5. **Validates formula** - Runs `brew audit` if available

## Validate Generated Formula

After running the test script, validate the generated formula:

```bash
releasing/validate-formula.sh Formula/elm-wrap.rb.test
```

This checks:
- ✓ Ruby syntax
- ✓ Required formula fields
- ✓ No template placeholders remain
- ✓ SHA256 checksums are valid (64 hex characters)
- ✓ Brew audit compliance

## Test Output

The script will create:
- `elm-wrap-macos-arm64` - Downloaded ARM64 binary
- `elm-wrap-macos-amd64` - Downloaded AMD64 binary  
- `Formula/elm-wrap.rb.test` - Generated formula file

## Cleanup

Remove test artifacts:

```bash
rm -f elm-wrap-macos-arm64 elm-wrap-macos-amd64 Formula/elm-wrap.rb.test
```

## Common Issues Fixed

### Issue: Heredoc variable interpolation in YAML

**Problem:** Using `<<EOF` in GitHub Actions causes shell variable interpolation issues with Ruby's `#{}` syntax.

**Solution:** Switched to `printf` with explicit line breaks, avoiding heredoc entirely.

### Issue: Missing error handling for downloads

**Problem:** If a release binary is missing, `curl` would silently fail.

**Solution:** Added `-f` flag to `curl` and explicit error checking with proper error messages.

### Issue: Formula validation failures

**Problem:** `brew audit` might fail if testing against a non-existent release.

**Solution:** Test with an actual published release tag to ensure binaries exist.

## Testing Workflow Dispatch Locally

### Option 1: GitHub CLI (Recommended)

To simulate the GitHub `repository_dispatch` event:

```bash
# Trigger the workflow manually (requires gh CLI and proper permissions)
gh api repos/dsimunic/homebrew-elm-wrap/dispatches \
  -X POST \
  -f event_type=elm-wrap-release \
  -f client_payload[version]=v1.0.0
```

### Option 2: Using `act` (GitHub Actions local runner)

Install and run with act:

```bash
# Install act if not already installed
brew install act

# Create a test event payload
cat > .github/workflows/test-event.json <<'EOF'
{
  "action": "elm-wrap-release",
  "client_payload": {
    "version": "v1.0.0"
  }
}
EOF

# Run the workflow locally
act repository_dispatch \
  --eventpath .github/workflows/test-event.json \
  -s GITHUB_TOKEN="your-token-here"
```

**Note**: `act` runs workflows in Docker containers, which provides a close approximation to GitHub Actions but may have minor differences.

## Verifying the Fix

After running the test script successfully:

1. ✓ Check that `Formula/elm-wrap.rb.test` has correct version numbers
2. ✓ Verify SHA256 checksums match the release artifacts
3. ✓ Ensure no template placeholders remain in the generated file
4. ✓ Run `./validate-formula.sh Formula/elm-wrap.rb.test`
5. ✓ Optional: Run `brew audit` on the test formula

## Complete Test Workflow

```bash
# 1. Run the workflow simulation
./test-workflow.sh v1.0.0

# 2. Validate the generated formula
./validate-formula.sh Formula/elm-wrap.rb.test

# 3. Inspect the output
cat Formula/elm-wrap.rb.test

# 4. Clean up
rm -f elm-wrap-macos-arm64 elm-wrap-macos-amd64 Formula/elm-wrap.rb.test
```

## Integration with CI/CD

Once the local test passes, the actual workflow will run when:
1. A new release is created in `dsimunic/elm-wrap`
2. The release workflow dispatches the `elm-wrap-release` event
3. This tap repository receives the dispatch and updates the formula

See `WORKFLOW_FIXES.md` for details on what was fixed and why.

## Troubleshooting

### Problem: "ERROR: Failed to download AMD64 binary"

**Cause**: The release doesn't have both binaries uploaded.

**Solution**: Ensure the main repository's release workflow completed successfully and uploaded both `elm-wrap-macos-arm64` and `elm-wrap-macos-amd64`.

### Problem: Formula validation fails

**Cause**: Generated formula has syntax errors or missing fields.

**Solution**: Run `./validate-formula.sh` to see specific errors, then check the template in the workflow file.

### Problem: SHA256 mismatch after installation

**Cause**: Release artifacts changed after formula was generated.

**Solution**: Re-run the workflow or regenerate the formula with the current release artifacts.

