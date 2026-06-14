#!/usr/bin/env bash
set -euo pipefail

REPO="${CCH_REPO:-<owner>/<repo>}"
VERSION="${CCH_VERSION:-latest}"
INSTALL_DIR="${CCH_INSTALL_DIR:-$HOME/.local/bin}"
BIN_NAME="${CCH_BIN_NAME:-cch}"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required" >&2
  exit 1
fi

if [ "$REPO" = "<owner>/<repo>" ]; then
  echo "Error: set CCH_REPO to your GitHub repository, for example owner/repo" >&2
  exit 2
fi

mkdir -p "$INSTALL_DIR"

if [ "$VERSION" = "latest" ]; then
  URL="https://github.com/$REPO/releases/latest/download/cch"
else
  URL="https://github.com/$REPO/releases/download/$VERSION/cch"
fi

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

curl -fsSL "$URL" -o "$TMP_FILE"
install -m 0755 "$TMP_FILE" "$INSTALL_DIR/$BIN_NAME"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "Installed to $INSTALL_DIR/$BIN_NAME"
    echo "Note: $INSTALL_DIR is not in PATH. Add it to your shell profile or run:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    exit 0
    ;;
esac

echo "Installed $BIN_NAME to $INSTALL_DIR/$BIN_NAME"
