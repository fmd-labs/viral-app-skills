#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="$ROOT_DIR/.tools/restish"
BIN_PATH="$INSTALL_DIR/restish"

VERSION="${RESTISH_VERSION:-0.21.2}"
OS_RAW="$(uname -s)"
ARCH_RAW="$(uname -m)"

case "$OS_RAW" in
  Darwin) OS="darwin" ;;
  Linux) OS="linux" ;;
  *)
    echo "Unsupported OS: $OS_RAW" >&2
    exit 1
    ;;
esac

case "$ARCH_RAW" in
  x86_64|amd64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH_RAW" >&2
    exit 1
    ;;
esac

ASSET="restish-${VERSION}-${OS}-${ARCH}.tar.gz"
URL="https://github.com/rest-sh/restish/releases/download/v${VERSION}/${ASSET}"

mkdir -p "$INSTALL_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL "$URL" -o "$TMP_DIR/$ASSET"
tar -xzf "$TMP_DIR/$ASSET" -C "$TMP_DIR"

if [[ ! -f "$TMP_DIR/restish" ]]; then
  echo "Install failed: restish binary not found in archive." >&2
  exit 1
fi

install -m 0755 "$TMP_DIR/restish" "$BIN_PATH"

echo "Installed restish v${VERSION} to $BIN_PATH"
