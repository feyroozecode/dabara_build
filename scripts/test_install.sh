#!/bin/sh
# Tests install.sh against a FAKE local release (no network, no real binary needed).
# Usage: sh scripts/test_install.sh        (exit code 0 = all passed)
# shellcheck disable=SC1090  # the installer is sourced from a computed path on purpose
set -u

HERE=$(cd "$(dirname "$0")/.." && pwd)
INSTALL="$HERE/install.sh"
WORK=$(mktemp -d)
SERVER_PID=""
PASS=0
FAIL=0

cleanup() { [ -n "$SERVER_PID" ] && kill "$SERVER_PID" 2>/dev/null; rm -rf "$WORK"; return 0; }
trap cleanup EXIT INT TERM

ok()   { PASS=$((PASS + 1)); printf '  ok    %s\n' "$1"; }
bad()  { FAIL=$((FAIL + 1)); printf '  FAIL  %s\n' "$1"; }
check() { # check <description> <command...>   (passes when the command succeeds)
  desc="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$desc"; else bad "$desc"; fi
}
check_not() { desc="$1"; shift; if "$@" >/dev/null 2>&1; then bad "$desc"; else ok "$desc"; fi; }

TARGET="x86_64-unknown-linux-musl"
TAG="v9.9.9-test"
ASSET="dabara-$TAG-$TARGET.tar.gz"

# ---- a fake release: the "binary" is a script that reports a version -------------------------------
REL="$WORK/rel"
mkdir -p "$REL/$TAG" "$WORK/pkg"
cat > "$WORK/pkg/dabara" <<'FAKE'
#!/bin/sh
case "${1:-}" in --version) echo "dabara 9.9.9-test (fake-target)" ;; *) echo "fake dabara ran: $*" ;; esac
FAKE
chmod +x "$WORK/pkg/dabara"
echo "licence text" > "$WORK/pkg/LICENSE"
tar -czf "$REL/$TAG/$ASSET" -C "$WORK/pkg" dabara LICENSE
if command -v sha256sum >/dev/null 2>&1; then SUM=$(sha256sum "$REL/$TAG/$ASSET" | cut -d' ' -f1); else SUM=$(shasum -a 256 "$REL/$TAG/$ASSET" | cut -d' ' -f1); fi
echo "$SUM  $ASSET" > "$REL/$TAG/$ASSET.sha256"

run() { # run <install dir> <args...> — installs from the fake release
  dir="$1"; shift
  DABARA_BASE_URL="file://$REL" DABARA_TARGET="$TARGET" DABARA_INSTALL_DIR="$dir" sh "$INSTALL" "$@"
}

echo "== happy path"
D="$WORK/home1/.dabara/bin"
out=$(run "$D" --version "$TAG" 2>&1); code=$?
[ $code -eq 0 ] && ok "exits 0" || bad "exits 0 (got $code)"
check "installed program exists and is executable" test -x "$D/dabara"
case "$out" in *"checksum ok"*) ok "verified the checksum" ;; *) bad "verified the checksum" ;; esac
case "$out" in *"dabara 9.9.9-test"*) ok "ran the installed program" ;; *) bad "ran the installed program: $out" ;; esac
case "$out" in *"Add Dabara to your PATH"*) ok "prints the PATH hint when the directory is not on PATH" ;; *) bad "PATH hint missing" ;; esac
out=$(PATH="$D:$PATH" run "$D" --version "$TAG" 2>&1)
case "$out" in *"Add Dabara to your PATH"*) bad "no PATH hint when already on PATH" ;; *) ok "no PATH hint when already on PATH" ;; esac
check "no temp files left in the install dir" test ! -e "$D/.dabara.new"
case "$out" in *"Try:  dabara sabo"*) ok "tells the user what to try next" ;; *) bad "next-step hint" ;; esac

echo "== version spelling"
D="$WORK/home2/bin"
check "accepts a tag without the leading v" run "$D" --version "9.9.9-test"
check "...and installed it" test -x "$D/dabara"

echo "== reinstall replaces"
D="$WORK/home3/bin"; mkdir -p "$D"; echo "old" > "$D/dabara"; chmod +x "$D/dabara"
check "overwrites an existing program" run "$D" --version "$TAG"
check "the new program is the real one" sh -c "\"$D/dabara\" --version | grep -q 9.9.9-test"

echo "== verification failures install NOTHING"
D="$WORK/home4/bin"
cp -r "$REL" "$WORK/rel_bad"; echo "0000000000000000000000000000000000000000000000000000000000000000  x" > "$WORK/rel_bad/$TAG/$ASSET.sha256"
out=$(DABARA_BASE_URL="file://$WORK/rel_bad" DABARA_TARGET="$TARGET" DABARA_INSTALL_DIR="$D" sh "$INSTALL" --version "$TAG" 2>&1); code=$?
[ $code -ne 0 ] && ok "wrong checksum: non-zero exit" || bad "wrong checksum: non-zero exit"
case "$out" in *"checksum mismatch"*) ok "wrong checksum: says so" ;; *) bad "wrong checksum: says so ($out)" ;; esac
check "wrong checksum: nothing installed" test ! -e "$D/dabara"

rm "$WORK/rel_bad/$TAG/$ASSET.sha256"
out=$(DABARA_BASE_URL="file://$WORK/rel_bad" DABARA_TARGET="$TARGET" DABARA_INSTALL_DIR="$D" sh "$INSTALL" --version "$TAG" 2>&1); code=$?
[ $code -ne 0 ] && ok "missing checksum file: refuses" || bad "missing checksum file: refuses"
case "$out" in *"unverified"*) ok "missing checksum file: explains why" ;; *) bad "missing checksum file: explains ($out)" ;; esac
check "missing checksum file: nothing installed" test ! -e "$D/dabara"

out=$(run "$D" --version v0.0.0-nope 2>&1); code=$?
[ $code -ne 0 ] && ok "unknown version: non-zero exit" || bad "unknown version: non-zero exit"
case "$out" in *"could not download"*) ok "unknown version: clear message" ;; *) bad "unknown version: clear message ($out)" ;; esac
check "unknown version: nothing installed" test ! -e "$D/dabara"

mkdir -p "$WORK/rel_empty/$TAG"; tar -czf "$WORK/rel_empty/$TAG/$ASSET" -C "$WORK/pkg" LICENSE
( cd "$WORK/rel_empty/$TAG" && if command -v sha256sum >/dev/null 2>&1; then sha256sum "$ASSET"; else shasum -a 256 "$ASSET"; fi > "$ASSET.sha256" )
out=$(DABARA_BASE_URL="file://$WORK/rel_empty" DABARA_TARGET="$TARGET" DABARA_INSTALL_DIR="$D" sh "$INSTALL" --version "$TAG" 2>&1); code=$?
[ $code -ne 0 ] && ok "archive without a program: refuses" || bad "archive without a program: refuses"
check "archive without a program: nothing installed" test ! -e "$D/dabara"

echo "== options"
D="$WORK/home5/bin"
out=$(run "$D" --version "$TAG" --dry-run 2>&1); code=$?
[ $code -eq 0 ] && ok "--dry-run exits 0" || bad "--dry-run exits 0"
check "--dry-run installs nothing" test ! -e "$D/dabara"
case "$out" in *"$ASSET"*) ok "--dry-run names the file it would fetch" ;; *) bad "--dry-run names the file" ;; esac
check_not "unknown option is an error" run "$D" --bogus
check_not "--version without a value is an error" run "$D" --version
check "--help exits 0" sh "$INSTALL" --help
out=$(sh "$INSTALL" --help 2>&1); case "$out" in *"--uninstall"*) ok "--help lists the options" ;; *) bad "--help lists the options" ;; esac
out=$(cat "$INSTALL" | sh -s -- --help 2>&1); case "$out" in *"--dry-run"*) ok "--help works when the script is piped to sh" ;; *) bad "--help via pipe" ;; esac
D="$WORK/home6/custom"; check "--dir installs there" run "$D" --version "$TAG" --dir "$D"
check "--dir result exists" test -x "$D/dabara"

echo "== uninstall"
D="$WORK/home7/.dabara/bin"; run "$D" --version "$TAG" >/dev/null 2>&1
check "uninstall exits 0" run "$D" --uninstall
check "uninstall removes the program" test ! -e "$D/dabara"
check "uninstall removes the now-empty ~/.dabara/bin and ~/.dabara" test ! -e "$WORK/home7/.dabara"
check "uninstall when nothing is installed exits 0" run "$D" --uninstall
D="$WORK/home8/bin"; mkdir -p "$D"; echo "other" > "$D/keep.txt"; echo x > "$D/dabara"
run "$D" --uninstall >/dev/null 2>&1
check "uninstall leaves other files alone" test -f "$D/keep.txt"
D="$WORK/home9/bin"; run "$D" --version "$TAG" >/dev/null 2>&1
out=$(run "$D" --uninstall --dry-run 2>&1); check "--uninstall --dry-run keeps the program" test -x "$D/dabara"

echo "== platform detection"
(
  DABARA_INSTALL_SOURCE_ONLY=1
  export DABARA_INSTALL_SOURCE_ONLY
  . "$INSTALL"
  t() { [ "$(detect_target "$1" "$2" "$3")" = "$4" ]; }
  t Linux x86_64 0 x86_64-unknown-linux-musl && echo "ok linux-x64"
  t Linux aarch64 0 aarch64-unknown-linux-musl && echo "ok linux-arm64"
  t Linux amd64 0 x86_64-unknown-linux-musl && echo "ok amd64-alias"
  t Darwin arm64 0 aarch64-apple-darwin && echo "ok mac-arm"
  t Darwin x86_64 0 x86_64-apple-darwin && echo "ok mac-intel"
  t Linux aarch64 1 aarch64-linux-android && echo "ok termux"
) > "$WORK/detect.out" 2>&1
for name in linux-x64 linux-arm64 amd64-alias mac-arm mac-intel termux; do
  grep -q "ok $name" "$WORK/detect.out" && ok "detects $name" || bad "detects $name"
done
out=$( (DABARA_INSTALL_SOURCE_ONLY=1; . "$INSTALL"; detect_target FreeBSD x86_64 0) 2>&1 ); code=$?
[ $code -ne 0 ] && ok "rejects an unsupported OS" || bad "rejects an unsupported OS"
case "$out" in *"install.ps1"*) ok "...and points Windows users to install.ps1" ;; *) bad "points to install.ps1 ($out)" ;; esac
out=$( (DABARA_INSTALL_SOURCE_ONLY=1; . "$INSTALL"; detect_target Linux riscv64 0) 2>&1 ); code=$?
[ $code -ne 0 ] && ok "rejects an unsupported CPU" || bad "rejects an unsupported CPU"
out=$( (DABARA_INSTALL_SOURCE_ONLY=1; . "$INSTALL"; detect_target Linux x86_64 1) 2>&1 ); code=$?
[ $code -ne 0 ] && ok "rejects Android on non-arm64" || bad "rejects Android on non-arm64"

echo "== 'latest' over HTTP (what real users do)"
if command -v python3 >/dev/null 2>&1; then
  mkdir -p "$WORK/www/dl"
  cp -r "$REL/$TAG" "$WORK/www/dl/$TAG"
  # the GitHub "list releases" shape, newest first, with a pre-release at the top
  printf '[{"tag_name": "%s", "prerelease": true}, {"tag_name": "v0.0.1"}]\n' "$TAG" > "$WORK/www/releases"
  PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')
  ( cd "$WORK/www" && exec python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 ) &
  SERVER_PID=$!
  i=0; while [ $i -lt 50 ]; do curl -fs "http://127.0.0.1:$PORT/releases" >/dev/null 2>&1 && break; i=$((i + 1)); sleep 0.1; done
  D="$WORK/home10/bin"
  out=$(DABARA_BASE_URL="http://127.0.0.1:$PORT/dl" DABARA_API_URL="http://127.0.0.1:$PORT/releases" DABARA_TARGET="$TARGET" DABARA_INSTALL_DIR="$D" sh "$INSTALL" 2>&1); code=$?
  [ $code -eq 0 ] && ok "default (latest) install succeeds over HTTP" || bad "latest over HTTP ($out)"
  case "$out" in *"Dabara $TAG for"*) ok "picked the newest tag, pre-release included" ;; *) bad "newest tag ($out)" ;; esac
  check "...and installed it" test -x "$D/dabara"
  printf 'not json at all' > "$WORK/www/releases"
  D="$WORK/home11/bin"
  out=$(DABARA_BASE_URL="http://127.0.0.1:$PORT/dl" DABARA_API_URL="http://127.0.0.1:$PORT/releases" DABARA_TARGET="$TARGET" DABARA_INSTALL_DIR="$D" sh "$INSTALL" 2>&1); code=$?
  [ $code -ne 0 ] && ok "no parsable release list: non-zero exit" || bad "no parsable release list"
  case "$out" in *"could not find a release"*) ok "...with a clear message" ;; *) bad "clear message ($out)" ;; esac
  check "...and nothing installed" test ! -e "$D/dabara"
else
  echo "  skip  python3 not available — HTTP tests skipped"
fi

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
