#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="${VIRAL_APP_BIN_DIR:-$HOME/.local/bin}"
GLOBAL_CMD="$BIN_DIR/viral-app"

"$ROOT_DIR/scripts/install-restish.sh"

mkdir -p "$BIN_DIR"
cat > "$GLOBAL_CMD" <<EOS
#!/usr/bin/env bash
set -euo pipefail
exec "$ROOT_DIR/bin/viral-app" "\$@"
EOS
chmod +x "$GLOBAL_CMD"

echo "Installed global viral-app command: $GLOBAL_CMD"

case ":$PATH:" in
  *":$BIN_DIR:"*)
    echo "PATH already contains $BIN_DIR"
    ;;
  *)
    echo
    echo "Add this to your shell profile to use 'viral-app' directly:"
    echo "export PATH=\"$BIN_DIR:\$PATH\""
    ;;
esac

echo
"$GLOBAL_CMD" --help >/dev/null
echo "viral-app is ready. Try: viral-app accounts-list --per-page 2"
