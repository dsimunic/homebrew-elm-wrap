#!/usr/bin/env bash
set -euo pipefail

# Local testing script for update-elm-wrap.yml workflow
# Usage: ./test-workflow.sh <version-tag>
# Example: ./test-workflow.sh v0.1.0

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# The tap root is one level up from releasing/
TAP_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version-tag>"
  echo "Example: $0 v0.1.0"
  exit 1
fi

TAG="$1"
VERSION="${TAG#v}"

echo "Testing workflow with:"
echo "  TAG: $TAG"
echo "  VERSION: $VERSION"
echo ""

# Step 1: Set version variables (simulated)
echo "=== Step 1: Set version variables ==="
echo "tag=$TAG"
echo "version=$VERSION"
echo ""

# Step 2: Download release artifacts and compute checksums
echo "=== Step 2: Download release artifacts and compute checksums ==="
ARM_URL="https://github.com/dsimunic/elm-wrap/releases/download/${TAG}/elm-wrap-macos-arm64"
AMD_URL="https://github.com/dsimunic/elm-wrap/releases/download/${TAG}/elm-wrap-macos-amd64"

echo "Downloading $ARM_URL"
if curl -L -f -o "$TAP_ROOT/elm-wrap-macos-arm64" "$ARM_URL"; then
  ARM_SHA=$(shasum -a 256 "$TAP_ROOT/elm-wrap-macos-arm64" | awk '{print $1}')
  echo "ARM SHA256: $ARM_SHA"
else
  echo "ERROR: Failed to download ARM64 binary"
  exit 1
fi

echo ""
echo "Downloading $AMD_URL"
if curl -L -f -o "$TAP_ROOT/elm-wrap-macos-amd64" "$AMD_URL"; then
  AMD_SHA=$(shasum -a 256 "$TAP_ROOT/elm-wrap-macos-amd64" | awk '{print $1}')
  echo "AMD64 SHA256: $AMD_SHA"
else
  echo "ERROR: Failed to download AMD64 binary"
  rm -f "$TAP_ROOT/elm-wrap-macos-arm64"
  exit 1
fi

echo ""
echo "arm_sha=$ARM_SHA"
echo "amd_sha=$AMD_SHA"
echo ""

# Step 3: Update elm-wrap formula
echo "=== Step 3: Update elm-wrap formula ==="
FORMULA="$TAP_ROOT/Formula/elm-wrap.rb.test"

printf '%s\n' \
  'class ElmWrap < Formula' \
  '  desc "Elm package management wrapper with custom registry support"' \
  '  homepage "https://github.com/dsimunic/elm-wrap"' \
  "  version \"${VERSION}\"" \
  '  license "MIT"' \
  '' \
  '  on_macos do' \
  '    if Hardware::CPU.arm?' \
  "      url \"https://github.com/dsimunic/elm-wrap/releases/download/${TAG}/elm-wrap-macos-arm64\"" \
  "      sha256 \"${ARM_SHA}\"" \
  '    else' \
  "      url \"https://github.com/dsimunic/elm-wrap/releases/download/${TAG}/elm-wrap-macos-amd64\"" \
  "      sha256 \"${AMD_SHA}\"" \
  '    end' \
  '  end' \
  '' \
  '  def install' \
  '    if OS.mac? && Hardware::CPU.arm?' \
  '      bin.install "elm-wrap-macos-arm64" => "elm-wrap"' \
  '    else' \
  '      bin.install "elm-wrap-macos-amd64" => "elm-wrap"' \
  '    end' \
  '  end' \
  '' \
  '  test do' \
  '    output = shell_output("#{bin}/elm-wrap --help")' \
  '    assert_match "elm-wrap", output' \
  '  end' \
  'end' > "$FORMULA"

echo "Generated formula saved to: $FORMULA"
echo ""
echo "=== Formula content ==="
cat "$FORMULA"
echo ""

# Step 4: Validate the formula (if brew is available)
if command -v brew >/dev/null 2>&1; then
  echo "=== Step 4: Validating formula with brew ==="
  if brew audit --strict --online "$FORMULA" 2>&1; then
    echo "Formula validation passed!"
  else
    echo "WARNING: Formula validation failed (this might be expected for test file)"
  fi
else
  echo "=== Step 4: Skipping validation (brew not available) ==="
fi

echo ""
echo "=== Test Summary ==="
echo "✓ Version variables set correctly"
echo "✓ Release artifacts downloaded successfully"
echo "✓ SHA256 checksums computed"
echo "✓ Formula file generated"
echo ""
echo "To apply changes to actual formula:"
echo "  cp $FORMULA $TAP_ROOT/Formula/elm-wrap.rb"
echo ""
echo "Cleanup test files:"
echo "  rm -f $TAP_ROOT/elm-wrap-macos-arm64 $TAP_ROOT/elm-wrap-macos-amd64 $FORMULA"
