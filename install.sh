#!/bin/sh
# Dabara installer — macOS, Linux and Termux (Android).
#
#   curl -fsSL https://raw.githubusercontent.com/feyroozecode/dabara_build/main/install.sh | sh
#   curl -fsSL .../install.sh | sh -s -- --version v0.6.0-beta.1
#
# Installs the prebuilt `dabara` program into ~/.dabara/bin. No sudo, no compiler, no source.
# The download is checked against its published SHA-256 before anything is installed.
#
# Options:   --version <tag>   install a specific release (default: the newest, pre-releases included)
#            --dir <path>      install somewhere else      (default: ~/.dabara/bin)
#            --dry-run         say what would happen, change nothing
#            --uninstall       remove the installed program
#            --help
# Advanced:  DABARA_REPO, DABARA_BASE_URL, DABARA_API_URL, DABARA_TARGET (all read below)

set -eu

REPO="${DABARA_REPO:-feyroozecode/dabara_build}"
BASE_URL="${DABARA_BASE_URL:-https://github.com/$REPO/releases/download}"   # <BASE_URL>/<tag>/<asset>
API_URL="${DABARA_API_URL:-https://api.github.com/repos/$REPO/releases}"
INSTALL_DIR="${DABARA_INSTALL_DIR:-${HOME:-.}/.dabara/bin}"
VERSION="${DABARA_VERSION:-latest}"
TARGET="${DABARA_TARGET:-}"
DRY_RUN=0
UNINSTALL=0
TMP=""

say() { printf '%s\n' "$*"; }
die() { printf 'dabara-install: error: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

cleanup() { if [ -n "$TMP" ]; then rm -rf "$TMP"; fi; return 0; }
trap cleanup EXIT INT TERM

usage() {
  cat <<'USAGE'
Dabara installer — macOS, Linux and Termux (Android).

  curl -fsSL https://raw.githubusercontent.com/feyroozecode/dabara_build/main/install.sh | sh
  curl -fsSL .../install.sh | sh -s -- --version v0.6.0-beta.1

Installs the prebuilt `dabara` program into ~/.dabara/bin (no sudo, no source). The download is
checked against its published SHA-256 before anything is installed.

Options:
  --version <tag>   install a specific release (default: the newest, pre-releases included)
  --dir <path>      install somewhere else (default: ~/.dabara/bin)
  --dry-run         say what would happen, change nothing
  --uninstall       remove the installed program
  --help            this text
USAGE
}

# detect_target <uname -s> <uname -m> <is_android 0|1>  ->  prints the release target triple
detect_target() {
  os="$1"; arch="$2"; android="$3"
  case "$arch" in
    x86_64|amd64) cpu=x86_64 ;;
    arm64|aarch64) cpu=aarch64 ;;
    *) die "unsupported CPU '$arch' (supported: x86_64, arm64)" ;;
  esac
  case "$os" in
    Darwin) printf '%s-apple-darwin\n' "$cpu" ;;
    Linux)
      if [ "$android" = 1 ]; then
        [ "$cpu" = aarch64 ] || die "Android is supported on arm64 only"
        printf 'aarch64-linux-android\n'
      else
        printf '%s-unknown-linux-musl\n' "$cpu"
      fi ;;
    *) die "unsupported system '$os' (on Windows use install.ps1)" ;;
  esac
}

is_android() {
  [ -n "${TERMUX_VERSION:-}" ] && return 0
  [ "$(uname -o 2>/dev/null || true)" = "Android" ] && return 0
  return 1
}

fetch() { # fetch <url> <dest>
  if have curl; then curl -fsSL --retry 2 -o "$2" "$1"
  elif have wget; then wget -q -O "$2" "$1"
  else die "need curl or wget"; fi
}

fetch_stdout() { # fetch_stdout <url>
  if have curl; then curl -fsSL --retry 2 "$1"
  elif have wget; then wget -q -O - "$1"
  else die "need curl or wget"; fi
}

sha256_of() { # sha256_of <file>
  if have sha256sum; then sha256sum "$1" | cut -d' ' -f1
  elif have shasum; then shasum -a 256 "$1" | cut -d' ' -f1
  elif have openssl; then openssl dgst -sha256 "$1" | sed 's/^.*= //'
  else die "need sha256sum, shasum or openssl to verify the download"; fi
}

# newest release tag, pre-releases included (the "latest" redirect GitHub offers skips them)
latest_tag() {
  # first "tag_name" wherever it sits (pretty-printed or compact JSON): extract each pair, take the first
  tag=$(fetch_stdout "$API_URL?per_page=1" | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed 's/.*"\([^"]*\)"$/\1/') || true
  [ -n "$tag" ] || die "could not find a release at $API_URL — is anything published yet? Try --version <tag>"
  printf '%s\n' "$tag"
}

path_hint() {
  case ":${PATH:-}:" in
    *":$INSTALL_DIR:"*) return 0 ;;
  esac
  say ""
  say "Add Dabara to your PATH:"
  case "${SHELL:-}" in
    */fish) say "  fish_add_path $INSTALL_DIR" ;;
    */zsh)  say "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc && exec zsh" ;;
    *)      say "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.profile && . ~/.profile" ;;
  esac
}

do_uninstall() {
  dest="$INSTALL_DIR/dabara"
  if [ ! -e "$dest" ]; then say "Nothing to remove: $dest does not exist."; return 0; fi
  if [ "$DRY_RUN" = 1 ]; then say "[dry run] would remove $dest"; return 0; fi
  rm -f "$dest"
  rmdir "$INSTALL_DIR" 2>/dev/null || true
  case "$INSTALL_DIR" in */.dabara/bin) rmdir "$(dirname "$INSTALL_DIR")" 2>/dev/null || true ;; esac
  say "Removed $dest. (If you added $INSTALL_DIR to your PATH, you can remove that line too.)"
}

main() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --version) [ $# -ge 2 ] || die "--version needs a value"; VERSION="$2"; shift 2 ;;
      --dir)     [ $# -ge 2 ] || die "--dir needs a value"; INSTALL_DIR="$2"; shift 2 ;;
      --dry-run) DRY_RUN=1; shift ;;
      --uninstall) UNINSTALL=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown option '$1' (try --help)" ;;
    esac
  done

  if [ "$UNINSTALL" = 1 ]; then do_uninstall; exit 0; fi

  if [ -z "$TARGET" ]; then
    android=0; is_android && android=1
    TARGET=$(detect_target "$(uname -s)" "$(uname -m)" "$android")
  fi

  if [ "$VERSION" = latest ]; then
    TAG=$(latest_tag)
  else
    case "$VERSION" in v*) TAG="$VERSION" ;; *) TAG="v$VERSION" ;; esac
  fi

  ASSET="dabara-$TAG-$TARGET.tar.gz"
  URL="$BASE_URL/$TAG/$ASSET"

  say "Dabara $TAG for $TARGET"
  say "  from  $URL"
  say "  to    $INSTALL_DIR/dabara"
  if [ "$DRY_RUN" = 1 ]; then say "[dry run] nothing downloaded or installed."; exit 0; fi

  TMP=$(mktemp -d 2>/dev/null || mktemp -d -t dabara)
  fetch "$URL" "$TMP/$ASSET" || die "could not download $URL (is $TAG published for $TARGET?)"
  fetch "$URL.sha256" "$TMP/$ASSET.sha256" || die "could not download the checksum $URL.sha256 — refusing to install an unverified file"

  expected=$(cut -d' ' -f1 < "$TMP/$ASSET.sha256" | tr 'A-F' 'a-f')
  actual=$(sha256_of "$TMP/$ASSET" | tr 'A-F' 'a-f')
  [ -n "$expected" ] || die "the checksum file is empty"
  if [ "$expected" != "$actual" ]; then
    die "checksum mismatch — the download is corrupt or has been tampered with (expected $expected, got $actual). Nothing was installed."
  fi
  say "  checksum ok ($actual)"

  mkdir "$TMP/x"
  tar -xzf "$TMP/$ASSET" -C "$TMP/x" || die "could not unpack the archive"
  found=$(find "$TMP/x" -type f -name dabara | head -n 1)
  [ -n "$found" ] || die "the archive does not contain a 'dabara' program"

  mkdir -p "$INSTALL_DIR" || die "cannot create $INSTALL_DIR"
  cp "$found" "$INSTALL_DIR/.dabara.new" && chmod 755 "$INSTALL_DIR/.dabara.new" \
    && mv -f "$INSTALL_DIR/.dabara.new" "$INSTALL_DIR/dabara" || die "cannot write to $INSTALL_DIR"
  if [ "$(uname -s)" = Darwin ]; then xattr -d com.apple.quarantine "$INSTALL_DIR/dabara" 2>/dev/null || true; fi

  say ""
  "$INSTALL_DIR/dabara" --version || die "installed, but the program does not run on this machine"
  path_hint
  say ""
  say "Try:  dabara sabo hello && cd hello && dabara gudana"
}

# Lets the tests load the functions above without running an install.
if [ "${DABARA_INSTALL_SOURCE_ONLY:-0}" != 1 ]; then main "$@"; fi
