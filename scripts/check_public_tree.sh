#!/bin/sh
# The "no source" guard for this PUBLIC repository.
#   sh scripts/check_public_tree.sh [root]        exit 0 = clean, 1 = something must not be here
# Rejects: source files, build manifests, binaries/archives, source-looking directories, oversized
# files, and internals leaking into the docs/examples/README (source paths, Rust types, private names).
set -u
ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$ROOT" || exit 2
bad=0
report() { printf 'NOT ALLOWED: %s\n' "$1"; bad=1; }

# 1. forbidden files (anything that is, or builds, the program)
for f in $(find . -path ./.git -prune -o -type f \( \
    -name '*.rs' -o -name 'Cargo.toml' -o -name 'Cargo.lock' -o -name 'build.rs' \
    -o -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.o' -o -name '*.a' \
    -o -name '*.exe' -o -name '*.dll' -o -name '*.so' -o -name '*.dylib' -o -name '*.wasm' \
    -o -name '*.tar.gz' -o -name '*.tgz' -o -name '*.zip' -o -name '*.vsix' -o -name '*.rlib' \) -print | sed 's|^\./||'); do
  report "$f (source, build file or binary — binaries belong in Releases, not in git)"
done

# 2. forbidden directories
for d in src target node_modules plans .cargo; do
  if find . -path ./.git -prune -o -type d -name "$d" -print | grep -q .; then
    report "a directory named '$d' ($(find . -path ./.git -prune -o -type d -name "$d" -print | head -1 | sed 's|^\./||'))"
  fi
done

# 3. size: nothing big hides in here
big=$(find . -path ./.git -prune -o -type f -size +2048k -print | sed 's|^\./||')
if [ -n "$big" ]; then
  printf '%s\n' "$big" | while IFS= read -r f; do printf 'NOT ALLOWED: %s is larger than 2 MB\n' "$f"; done
  bad=1
fi

# 4. internals leaking into what people read
LEAKS='(^|[^[:alnum:]_])(src/|tests/|plans/)|\.rs([^[:alnum:]_]|$)|Rc<|RefCell|HashMap<|[^[:alnum:]]cargo[^[:alnum:]]|exec_block|scope_stack|/Users/|dabara_lang|panicked at'
files=$(mktemp)
find docs examples README.md -type f \( -name '*.md' -o -name '*.ha' -o -name '*.txt' \) 2>/dev/null > "$files"
while IFS= read -r f; do
  if grep -En "$LEAKS" "$f" >/tmp/leak.$$ 2>/dev/null; then
    while IFS= read -r line; do report "$f:$line   (internals leak)"; done < /tmp/leak.$$
  fi
done < "$files"
rm -f "$files"
rm -f /tmp/leak.$$

if [ "$bad" -eq 0 ]; then echo "public tree is clean"; else echo "public tree check FAILED"; fi
exit "$bad"
