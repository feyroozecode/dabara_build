#!/bin/sh
# Tests for check_public_tree.sh: each case plants ONE violation in a temp tree and expects a failure.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
CHECK="$HERE/check_public_tree.sh"
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT INT TERM
PASS=0; FAIL=0

fresh() { rm -rf "$W/t"; mkdir -p "$W/t/docs" "$W/t/examples/v1" "$W/t/scripts"; echo "# Guide" > "$W/t/docs/GUIDE.md"; echo 'rubuta "Sannu"' > "$W/t/examples/v1/a.ha"; echo "# readme" > "$W/t/README.md"; echo "echo hi" > "$W/t/install.sh"; }
expect_clean() { fresh; [ -n "${2:-}" ] && eval "$2"; if sh "$CHECK" "$W/t" >/dev/null 2>&1; then PASS=$((PASS+1)); echo "  ok    $1"; else FAIL=$((FAIL+1)); echo "  FAIL  $1 (should be clean)"; fi; }
expect_dirty() { fresh; eval "$2"; sh "$CHECK" "$W/t" >/dev/null 2>&1; code=$?
  if [ $code -ne 0 ]; then PASS=$((PASS+1)); echo "  ok    $1"; else FAIL=$((FAIL+1)); echo "  FAIL  $1 (should be rejected)"; fi; }

echo "== accepts"
expect_clean "a normal tree"
expect_clean "dabara code and prose" 'echo "naɗa x = 1 # tests are programs" >> "$W/t/docs/GUIDE.md"'
expect_clean "words that merely contain a pattern (resources/, testsuite)" 'echo "see resources/ and testsuite" >> "$W/t/docs/GUIDE.md"'
expect_clean "a git directory is ignored" 'mkdir -p "$W/t/.git/src"; echo x > "$W/t/.git/src/a.rs"'

echo "== rejects source and binaries"
expect_dirty "a Rust file" 'echo "fn main(){}" > "$W/t/lib.rs"'
expect_dirty "a Rust file nested deep" 'mkdir -p "$W/t/docs/a/b"; echo x > "$W/t/docs/a/b/x.rs"'
expect_dirty "Cargo.toml" 'echo "[package]" > "$W/t/Cargo.toml"'
expect_dirty "Cargo.lock" 'echo x > "$W/t/Cargo.lock"'
expect_dirty "build.rs" 'echo x > "$W/t/build.rs"'
expect_dirty "C source" 'echo x > "$W/t/x.c"'
expect_dirty "an .exe" 'echo x > "$W/t/dabara.exe"'
expect_dirty "a .dll" 'echo x > "$W/t/x.dll"'
expect_dirty "a .wasm" 'echo x > "$W/t/x.wasm"'
expect_dirty "a release archive" 'echo x > "$W/t/dabara.tar.gz"'
expect_dirty "a zip" 'echo x > "$W/t/dabara.zip"'
expect_dirty "a .vsix" 'echo x > "$W/t/x.vsix"'

echo "== rejects directories and size"
expect_dirty "a src/ directory" 'mkdir "$W/t/src"; echo x > "$W/t/src/x.txt"'
expect_dirty "a nested src/ directory" 'mkdir -p "$W/t/docs/src"'
expect_dirty "a target/ directory" 'mkdir "$W/t/target"'
expect_dirty "node_modules" 'mkdir "$W/t/node_modules"'
expect_dirty "plans/" 'mkdir "$W/t/plans"'
expect_dirty "a file over 2 MB" 'dd if=/dev/zero of="$W/t/big.dat" bs=1024 count=2100 2>/dev/null'

echo "== rejects internals in what people read"
expect_dirty "a source path in the guide" 'echo "implemented in src/interpreter.rs" >> "$W/t/docs/GUIDE.md"'
expect_dirty "a tests/ path" 'echo "see tests/test_x.rs" >> "$W/t/docs/GUIDE.md"'
expect_dirty "a plans/ path" 'echo "see plans/roadmap" >> "$W/t/README.md"'
expect_dirty "a Rust type" 'echo "uses Rc<RefCell<X>>" >> "$W/t/docs/GUIDE.md"'
expect_dirty "cargo" 'echo "run cargo build" >> "$W/t/README.md"'
expect_dirty "the private repository name" 'echo "https://github.com/x/dabara_lang" >> "$W/t/README.md"'
expect_dirty "a home directory" 'echo "/Users/a/dev" >> "$W/t/docs/GUIDE.md"'
expect_dirty "panic output in an example" 'echo "# thread panicked at x" >> "$W/t/examples/v1/a.ha"'
expect_dirty "internals in a .txt example data file" 'echo "src/x" > "$W/t/examples/v1/d.txt"'

echo; echo "$PASS passed, $FAIL failed"; [ "$FAIL" -eq 0 ]
