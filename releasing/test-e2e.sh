#!/usr/bin/env bash
# Complete end-to-end test of the workflow
# This script runs both the workflow simulation and validation
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# The tap root is one level up from releasing/
TAP_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

usage() {
  echo "Usage: $0 <version-tag>"
  echo ""
  echo "Examples:"
  echo "  $0 v1.0.0"
  echo "  $0 v1.2.3"
  echo ""
  echo "This script will:"
  echo "  1. Run the workflow simulation (downloads binaries, generates formula)"
  echo "  2. Validate the generated formula"
  echo "  3. Show a summary of results"
  echo "  4. Clean up test artifacts"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

TAG="$1"
TEST_FORMULA="$TAP_ROOT/Formula/elm-wrap.rb.test"

echo "╔════════════════════════════════════════════════════════╗"
echo "║  End-to-End Workflow Test                              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Testing with version: $TAG"
echo ""

# Step 1: Run workflow simulation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Running workflow simulation..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! "$SCRIPT_DIR/test-workflow.sh" "$TAG"; then
  echo ""
  echo "✗ Workflow simulation failed!"
  echo "  Check that the release exists and has both binaries:"
  echo "  https://github.com/dsimunic/elm-wrap/releases/tag/$TAG"
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Validating generated formula..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! "$SCRIPT_DIR/validate-formula.sh" "$TEST_FORMULA"; then
  echo ""
  echo "✗ Formula validation failed!"
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

VERSION="${TAG#v}"
ARM_SHA=$(grep 'sha256' "$TEST_FORMULA" | head -1 | sed 's/.*sha256 "\([^"]*\)".*/\1/')
AMD_SHA=$(grep 'sha256' "$TEST_FORMULA" | tail -1 | sed 's/.*sha256 "\([^"]*\)".*/\1/')

echo "Version:     $VERSION"
echo "ARM64 SHA:   $ARM_SHA"
echo "AMD64 SHA:   $AMD_SHA"
echo ""
echo "Formula content:"
echo "────────────────────────────────────────────────────────"
cat "$TEST_FORMULA"
echo "────────────────────────────────────────────────────────"
echo ""

# Offer to install the test formula
if command -v brew >/dev/null 2>&1; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Optional: Test Installation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "To test installing from the generated formula:"
  echo ""
  echo "  brew install --formula $TEST_FORMULA"
  echo "  elm-wrap --help"
  echo "  brew uninstall elm-wrap"
  echo ""
fi

# Ask about cleanup
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cleanup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -n "Remove test artifacts? [y/N] "
read -r RESPONSE

if [[ "$RESPONSE" =~ ^[Yy]$ ]]; then
  echo "Cleaning up..."
  rm -f "$TAP_ROOT/elm-wrap-macos-arm64" "$TAP_ROOT/elm-wrap-macos-amd64" "$TEST_FORMULA"
  echo "✓ Test artifacts removed"
else
  echo "Test artifacts kept:"
  echo "  - $TAP_ROOT/elm-wrap-macos-arm64"
  echo "  - $TAP_ROOT/elm-wrap-macos-amd64"
  echo "  - $TEST_FORMULA"
  echo ""
  echo "To clean up manually:"
  echo "  rm -f $TAP_ROOT/elm-wrap-macos-arm64 $TAP_ROOT/elm-wrap-macos-amd64 $TEST_FORMULA"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  ✓ All tests passed!                                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "The workflow is ready to use. When you push a new release,"
echo "it will automatically update the Homebrew formula."
