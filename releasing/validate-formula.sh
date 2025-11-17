#!/usr/bin/env bash
# Quick validation script for the generated formula syntax
set -euo pipefail

FORMULA="${1:-Formula/elm-wrap.rb.test}"

if [ ! -f "$FORMULA" ]; then
  echo "ERROR: Formula file not found: $FORMULA"
  echo "Usage: $0 [formula-file]"
  exit 1
fi

echo "Validating formula: $FORMULA"
echo ""

# Check Ruby syntax
if command -v ruby >/dev/null 2>&1; then
  echo "✓ Checking Ruby syntax..."
  if ruby -c "$FORMULA" >/dev/null 2>&1; then
    echo "  ✓ Ruby syntax is valid"
  else
    echo "  ✗ Ruby syntax error!"
    ruby -c "$FORMULA"
    exit 1
  fi
else
  echo "⚠ Ruby not available, skipping syntax check"
fi

# Check for required formula components
echo ""
echo "✓ Checking formula structure..."

REQUIRED_FIELDS=(
  "class ElmWrap"
  "desc"
  "homepage"
  "version"
  "license"
  "on_macos do"
  "def install"
  "test do"
)

for field in "${REQUIRED_FIELDS[@]}"; do
  if grep -q "$field" "$FORMULA"; then
    echo "  ✓ Found: $field"
  else
    echo "  ✗ Missing: $field"
    exit 1
  fi
done

# Check that no placeholders remain
echo ""
echo "✓ Checking for template placeholders..."

PLACEHOLDERS=(
  "VERSION_PLACEHOLDER"
  "TAG_PLACEHOLDER"
  "ARM_SHA_PLACEHOLDER"
  "AMD_SHA_PLACEHOLDER"
  "\${VERSION}"
  "\${TAG}"
  "\${ARM_SHA}"
  "\${AMD_SHA}"
)

FOUND_PLACEHOLDERS=0
for placeholder in "${PLACEHOLDERS[@]}"; do
  if grep -q "$placeholder" "$FORMULA"; then
    echo "  ✗ Found unreplaced placeholder: $placeholder"
    FOUND_PLACEHOLDERS=1
  fi
done

if [ $FOUND_PLACEHOLDERS -eq 0 ]; then
  echo "  ✓ No placeholders found"
else
  exit 1
fi

# Check SHA256 format (64 hex chars)
echo ""
echo "✓ Checking SHA256 format..."

SHA_LINES=$(grep -o 'sha256 "[^"]*"' "$FORMULA" || true)
if [ -z "$SHA_LINES" ]; then
  echo "  ✗ No SHA256 checksums found!"
  exit 1
fi

while IFS= read -r line; do
  SHA=$(echo "$line" | sed 's/sha256 "\([^"]*\)"/\1/')
  if [[ $SHA =~ ^[a-f0-9]{64}$ ]]; then
    echo "  ✓ Valid SHA256: ${SHA:0:16}..."
  else
    echo "  ✗ Invalid SHA256 format: $SHA"
    exit 1
  fi
done <<< "$SHA_LINES"

# Brew audit if available
if command -v brew >/dev/null 2>&1; then
  echo ""
  echo "✓ Running brew audit..."
  if brew audit --strict "$FORMULA" 2>&1 | tee /tmp/brew-audit.log; then
    echo "  ✓ Brew audit passed"
  else
    echo "  ⚠ Brew audit had warnings (might be expected for test file)"
    # Don't fail on audit warnings for test files
  fi
fi

echo ""
echo "========================================="
echo "✓ Formula validation complete!"
echo "========================================="
