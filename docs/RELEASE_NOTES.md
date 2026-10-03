# Dabara — Release notes

What changed, for people who **use** Dabara. Newest first. Keyword and function names marked
*provisional* may still be renamed after review by native Hausa speakers (the old name will keep
working for at least one release).

## 0.6.0-beta.1 — tools, tests and a safer number model

**New command-line tools**
- `dabara sabo <name>` creates a project (`dabara.toml`, `main.ha`, a `gwaji/` test folder).
- `dabara gudana` runs a file or the project's entry point, from any folder inside the project.
- `dabara gwaji` runs the tests in `gwaji/` and tells you, in Hausa, which passed (exit code 1 if any failed).
- `dabara tsari` formats your code in one fixed style (comments kept); `dabara tsari --duba` only checks.
  It refuses to touch a file unless it can prove your program's meaning is unchanged.
- `dabara lsp` is a language server: error squiggles with their `DBR` code, completion and hover in
  any editor that supports it (the VS Code extension uses it).
- `dabara keywords --json` prints the whole vocabulary; `dabara --version` shows the platform.

**Writing tests** — `tabbatar(condition)` and `tabbatar_daidai(got, expected)` fail with `DBR-029`
and show both values, the file and the line. *(provisional names)*

**Fixed**
- `[1, 2] == [1, 2]` was an error; lists now compare element by element.
- **Integer overflow crashed the program.** `9223372036854775807 + 1` (and similar with `-`, `*`, `/`,
  `%`, unary `-`, `abs`) now stops with a normal, catchable error `DBR-030`.
- **A too-large number written in a program silently became `0`.** It is now error `DBR-031` with the
  line and column.
- `sum` of whole numbers is exact for very large values, and reports overflow instead of giving a
  wrong answer.
- Every error now carries a searchable `DBR-nnn` code (previously a few had none).

## 0.5.0 — "Ƙamus da Kayan Aiki" (data and tools)

- **Dictionaries**: `ƙamus { "suna": "Aisha" }`, read/write with `d["suna"]`, loop with `ga k cikin d`;
  `maɓallai`, `darajoji`, `ƙunshi`, `share`.
- **`babu`** (nothing): a function without `mayar` returns `babu` (it used to return `0`).
- **Functions are values**: anonymous `aiki(x) { … }`, closures that remember their variables,
  functions passed to `canza` (map) and `zaɓa` (filter).
- **Errors you can catch**: `gwada { … } kama (k) { … }` and `jefa value`. Errors raised by the language
  arrive as a dictionary with `"lamba"` (the `DBR` code) and `"saƙo"`. *(provisional names)*
- **Modules**: `fitar` exports, `shigo a, b daga "./fayil"` imports; each module runs once with its own
  variables; import cycles are reported with the chain.
- **Files**: `karanta_fayil`, `rubuta_fayil`, `akwai_fayil`; `tsaga` splits text into a list.
  *(provisional names)*
- New errors `DBR-021`–`DBR-028`.
- A three-file example program (`examples/v0.5/kasuwa/`) reads prices from a file, builds records,
  transforms them with closures, catches a bad line and writes a report.

## 0.4.0 — "Dabara ta zama Hausa" (Dabara becomes Hausa)

- **Hausa names for the whole standard library** (`tsawo`, `daraja`, `saiwa`, `datse`, `jera`, `canza`, …);
  English names keep working as aliases. *(provisional)*
- `naɗa` is the main way to declare a variable; `var` still works.
- **Searchable error codes** `DBR-001`–`DBR-020` on every error, with an index in the guide;
  `--turanci` switches the error labels to English.
- `fara` / `ƙare` are optional: a script can simply start writing statements.
- `ci gaba` (two words) works as well as `ci_gaba`; every hooked letter has an ASCII spelling.
- Error messages are Hausa only (French removed).

## 0.3.0 — "Harshe mai gaskiya" (a language that tells the truth)

Nine correctness problems fixed:
- `katse`, `ci gaba` and `mayar` now stop the rest of the enclosing block as expected.
- **Lexical scope**: a function sees its own variables and the file's globals, never its caller's locals.
- Logical operators `da`, `ko`, `ba` (with `!`), short-circuiting.
- `%` (remainder), string escapes (`\n \t \" \\ \u{…}`), `1 == 1.0`, alphabetical ordering of strings.
- Infinite recursion gives a Hausa error instead of crashing the program.
- `shigo`/`fitar` no longer silently do nothing (they were completed in 0.5.0).
