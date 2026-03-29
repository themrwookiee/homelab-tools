#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/bin"
DEST_DIR="/usr/local/sbin"

install -Dm755 "$SRC_DIR/ctupdate" "$DEST_DIR/ctupdate"

mkdir -p /etc/ctupdate

if [ ! -f /etc/ctupdate/ctupdate.conf ] && [ -f "$REPO_DIR/examples/ctupdate.conf.example" ]; then
  install -Dm644 "$REPO_DIR/examples/ctupdate.conf.example" /etc/ctupdate/ctupdate.conf
fi

if [ ! -f /etc/ctupdate/ignore.conf ] && [ -f "$REPO_DIR/examples/ignore.conf.example" ]; then
  install -Dm644 "$REPO_DIR/examples/ignore.conf.example" /etc/ctupdate/ignore.conf
fi

echo "✅ Installed ctupdate to $DEST_DIR/ctupdate"
echo "✅ Config directory ready at /etc/ctupdate"
