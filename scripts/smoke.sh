#!/bin/sh
# Smoke test of an INSTALLED dabara — what a stranger gets. Runs on Linux, macOS and Windows (Git Bash).
#   DABARA_BIN=/path/to/dabara sh scripts/smoke.sh           (examples/ is taken from this repository)
#   LEAK_CHECK=1 ...                                          also scan the binary for build-machine paths
set -u
BIN="${DABARA_BIN:-dabara}"
HERE=$(cd "$(dirname "$0")/.." && pwd)
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT INT TERM
PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); printf '  ok    %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '%s\n' "$2" | head -5 | sed 's/^/          /'; }

command -v "$BIN" >/dev/null 2>&1 || [ -x "$BIN" ] || { echo "dabara not found ($BIN)"; exit 2; }

echo "== version"
v=$("$BIN" --version 2>&1)
case "$v" in "dabara "[0-9]*.[0-9]*.[0-9]*" ("*")") ok "--version: $v" ;; *) bad "--version has an unexpected shape" "$v" ;; esac

echo "== examples (self-checking programs from this repository)"
cp -r "$HERE/examples" "$W/examples"
n=0
for f in "$W"/examples/v*/*.ha "$W"/examples/v*/*/main.ha; do
  [ -f "$f" ] || continue
  n=$((n+1)); rel=${f#"$W"/examples/}
  out=$("$BIN" "$f" 2>&1); code=$?
  if [ $code -eq 0 ] && ! printf '%s' "$out" | grep -Eq '^FAIL|Kuskure'; then ok "$rel"; else bad "$rel (exit $code)" "$out"; fi
done
[ "$n" -ge 8 ] && ok "ran $n examples" || bad "expected at least 8 examples, found $n"

echo "== a new project, end to end"
( cd "$W" && "$BIN" sabo hello >/dev/null 2>&1 ) && ok "dabara sabo" || bad "dabara sabo"
cd "$W/hello" || exit 2
out=$("$BIN" gudana 2>&1); [ "$out" = "Sannu, Duniya!" ] && ok "dabara gudana prints the greeting" || bad "dabara gudana" "$out"
out=$("$BIN" tsari --duba 2>&1); code=$?; [ $code -eq 0 ] && ok "a fresh project is already formatted (tsari --duba)" || bad "tsari --duba" "$out"
out=$("$BIN" gwaji 2>&1); code=$?; [ $code -eq 0 ] && ok "dabara gwaji passes on a fresh project" || bad "dabara gwaji" "$out"
printf 'tabbatar_daidai(2 * 3, 7, "ninka")\n' > gwaji/mummuna.ha
out=$("$BIN" gwaji 2>&1); code=$?
[ $code -eq 1 ] && ok "a failing test makes gwaji exit 1" || bad "failing test exit code ($code)" "$out"
printf '%s' "$out" | grep -q 'DBR-029' && ok "...and reports DBR-029" || bad "DBR-029 not reported" "$out"
printf 'naɗa x=1+2\nrubuta   x\n' > messy.ha
"$BIN" tsari messy.ha >/dev/null 2>&1
[ "$(cat messy.ha)" = "$(printf 'naɗa x = 1 + 2\nrubuta x')" ] && ok "dabara tsari formats a file" || bad "tsari output" "$(cat messy.ha)"

echo "== errors, not crashes"
cd "$W" || exit 2
printf 'rubuta 9223372036854775807 + 1\n' > ovf.ha
out=$("$BIN" ovf.ha 2>&1); code=$?
[ $code -eq 1 ] && printf '%s' "$out" | grep -q 'DBR-030' && ok "integer overflow is a clean DBR-030 error" || bad "overflow handling (exit $code)" "$out"
printf '%s' "$out" | grep -qi 'panick' && bad "overflow printed a panic message" "$out" || ok "no panic output"
printf 'rubuta 99999999999999999999\n' > lit.ha
out=$("$BIN" lit.ha 2>&1); printf '%s' "$out" | grep -q 'DBR-031' && ok "a too-large literal is DBR-031 (not silently 0)" || bad "literal handling" "$out"
printf 'rubuta 1 / 0\n' > div.ha
out=$("$BIN" div.ha 2>&1); code=$?; [ $code -eq 1 ] && printf '%s' "$out" | grep -q 'DBR-012' && ok "division by zero is DBR-012" || bad "division by zero" "$out"
out=$("$BIN" keywords --json 2>&1)
printf '%s' "$out" | grep -q '"keywords"' && printf '%s' "$out" | grep -q '"gwada"' && ok "keywords --json lists the vocabulary" || bad "keywords --json" "$out"

echo "== language server handshake"
frame() { printf 'Content-Length: %s\r\n\r\n%s' "${#1}" "$1"; }
{ frame '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}'
  frame '{"jsonrpc":"2.0","id":2,"method":"shutdown","params":null}'
  frame '{"jsonrpc":"2.0","method":"exit","params":{}}'; } > "$W/lsp.in"
"$BIN" lsp < "$W/lsp.in" > "$W/lsp.out" 2>/dev/null; code=$?
[ $code -eq 0 ] && ok "dabara lsp: clean shutdown (exit 0)" || bad "lsp exit code $code"
grep -q '"name":"dabara"' "$W/lsp.out" && ok "dabara lsp: answers initialize" || bad "lsp initialize reply" "$(head -c 300 "$W/lsp.out")"

if [ "${LEAK_CHECK:-0}" = 1 ]; then
  echo "== the binary does not carry the build machine's paths"
  bin=$(command -v "$BIN" 2>/dev/null || echo "$BIN")
  if grep -aEq '/Users/[A-Za-z0-9._-]+/|/home/[A-Za-z0-9._-]+/|C:\\Users\\|\.cargo/registry|\.rustup/' "$bin"; then
    bad "build-machine paths found in the binary" "$(grep -aEo '/Users/[A-Za-z0-9._-]+/[^ ]{0,40}|/home/[A-Za-z0-9._-]+/[^ ]{0,40}|C:\\Users\\[^ ]{0,40}|[^ ]{0,30}\.cargo/registry[^ ]{0,30}' "$bin" | head -3)"
  else ok "no home-directory or cargo-registry paths"; fi
fi

echo; echo "$PASS passed, $FAIL failed"; [ "$FAIL" -eq 0 ]
