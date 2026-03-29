#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_DIR/bin"

usage() {
  cat <<EOF
Usage:
  install-ct-scripts.sh all
  install-ct-scripts.sh <CTID> [CTID...]
EOF
}

ct_running() {
  local ctid="$1"
  [ "$(pct status "$ctid" 2>/dev/null | awk '{print $2}')" = "running" ]
}

ct_has_bash() {
  local ctid="$1"
  pct exec "$ctid" -- sh -c 'command -v bash >/dev/null 2>&1' >/dev/null 2>&1
}

ct_has_docker() {
  local ctid="$1"
  pct exec "$ctid" -- sh -c 'command -v docker >/dev/null 2>&1' >/dev/null 2>&1
}

install_to_ct() {
  local ctid="$1"

  echo "=============================="
  echo "📦 Installing scripts in CT $ctid"
  echo "=============================="

  if ! ct_running "$ctid"; then
    echo "⏭️  CT $ctid skipped (not running)"
    echo
    return 0
  fi

  if ! ct_has_bash "$ctid"; then
    echo "⏭️  CT $ctid skipped (bash not installed)"
    echo
    return 0
  fi

  if ! ct_has_docker "$ctid"; then
    echo "⏭️  CT $ctid skipped (no Docker)"
    echo
    return 0
  fi

  pct exec "$ctid" -- sh -c 'mkdir -p /usr/local/bin /etc/ctupdate'
  pct push "$ctid" "$SRC_DIR/update" /usr/local/bin/update
  pct push "$ctid" "$SRC_DIR/check-updates" /usr/local/bin/check-updates

  if [ -f "$REPO_DIR/examples/ctupdate.conf.example" ]; then
    pct push "$ctid" "$REPO_DIR/examples/ctupdate.conf.example" /etc/ctupdate/ctupdate.conf || true
  fi

  pct exec "$ctid" -- sh -c 'chmod +x /usr/local/bin/update /usr/local/bin/check-updates'

  echo "✅ Installed scripts in CT $ctid"
  echo
}

main() {
  command -v pct >/dev/null 2>&1 || {
    echo "❌ pct command not found. Run this on the Proxmox host."
    exit 1
  }

  [ "$#" -gt 0 ] || {
    usage
    exit 1
  }

  if [ "$1" = "all" ]; then
    while read -r ctid _; do
      [ -n "${ctid:-}" ] || continue
      [ "$ctid" = "VMID" ] && continue
      install_to_ct "$ctid"
    done < <(pct list)
    exit 0
  fi

  for ctid in "$@"; do
    install_to_ct "$ctid"
  done
}

main "$@"
