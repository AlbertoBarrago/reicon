#!/bin/zsh
# Links reicon into ~/.local/bin. Run with --uninstall to remove the link.

set -euo pipefail

readonly SOURCE=${0:A:h}/reicon
readonly BIN_DIR=$HOME/.local/bin
readonly TARGET=$BIN_DIR/reicon

if [[ ${1-} == --uninstall ]]; then
  if [[ -L $TARGET && ${TARGET:A} == "$SOURCE" ]]; then
    rm "$TARGET"
    print -- "Removed $TARGET"
  else
    print -u2 -- "$TARGET is not a link to $SOURCE: left untouched"
    exit 1
  fi
  exit 0
fi

# -L too: -e is false for a dangling link, which must not be silently replaced.
if [[ ( -e $TARGET || -L $TARGET ) && ! ( -L $TARGET && ${TARGET:A} == "$SOURCE" ) ]]; then
  print -u2 -- "$TARGET already exists and is not this reicon: remove it first"
  exit 1
fi

mkdir -p "$BIN_DIR"
chmod +x "$SOURCE"
ln -sf "$SOURCE" "$TARGET"
print -- "Linked $TARGET -> $SOURCE"

if (( ! ${path[(Ie)$BIN_DIR]} )); then
  print -- "\n$BIN_DIR is not in your PATH. Add this line to your shell profile (~/.zshrc, ~/.bash_profile):"
  print -- "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
