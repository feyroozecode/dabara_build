# Dabara — install, try, experiment

**Dabara** is a programming language whose keywords are Hausa: `naɗa`, `idan`, `maimaita`, `aiki`,
`gwada`/`kama`. This repository is the **public download page**: ready-made programs for every
platform, the documentation, examples, and the editor extension. The language's source code is not
public yet — you do not need it to install, learn and experiment.

> **Status: beta.** Names of keywords and functions are provisional until reviewed by native Hausa
> speakers; their meaning will not change. See the [release notes](docs/RELEASE_NOTES.md).

```hausa
naɗa suna = "Duniya"
rubuta "Sannu, " + suna + "!"
```

## Install

| Your system | One line |
|---|---|
| **macOS, Linux, Android (Termux)** | `curl -fsSL https://raw.githubusercontent.com/feyroozecode/dabara_build/main/install.sh \| sh` |
| **Windows** (PowerShell) | `irm https://raw.githubusercontent.com/feyroozecode/dabara_build/main/install.ps1 \| iex` |

No administrator rights, no compiler. The installer puts one program, `dabara`, in `~/.dabara/bin`
(Windows: `%USERPROFILE%\.dabara\bin`), **checks its SHA-256 before installing**, and tells you how to add
it to your `PATH`. Then:

```sh
dabara --version
dabara sabo hello      # create a project
cd hello
dabara gudana          # run it  →  Sannu, Duniya!
dabara gwaji           # run its tests
```

Options: `--version v0.6.0-beta.1` picks a release, `--dir PATH` another folder, `--dry-run` shows what
would happen, `--uninstall` removes it (`install.sh --help`; on Windows `-Version`, `-InstallDir`,
`-DryRun`, `-Uninstall`).

### Prefer to download by hand?
Every [release](../../releases) has one archive per platform plus a `.sha256` file:

| Platform | Archive |
|---|---|
| Linux x86-64 (any distribution, static) | `dabara-<version>-x86_64-unknown-linux-musl.tar.gz` |
| Linux ARM64 (Raspberry Pi, ARM servers) | `dabara-<version>-aarch64-unknown-linux-musl.tar.gz` |
| macOS Apple silicon | `dabara-<version>-aarch64-apple-darwin.tar.gz` |
| macOS Intel | `dabara-<version>-x86_64-apple-darwin.tar.gz` |
| Windows x64 | `dabara-<version>-x86_64-pc-windows-msvc.zip` |
| Android (Termux), ARM64 | `dabara-<version>-aarch64-linux-android.tar.gz` *(when published)* |

Check it: `shasum -a 256 -c dabara-….tar.gz.sha256` (macOS/Linux) or `Get-FileHash` (Windows), then unpack
and put `dabara` somewhere on your `PATH`.

## Learn

| | |
|---|---|
| [**User guide**](docs/GUIDE.md) | from "hello world" to functions, lists, dictionaries, errors, modules, files, tests |
| [**Language reference**](docs/LANGUAGE.md) | the exact rules — every example's output is machine-checked |
| [**Keywords & functions**](docs/KEYWORDS.md) | every word, with its meaning and ASCII spelling |
| [**Release notes**](docs/RELEASE_NOTES.md) | what changed in each version |
| [**Examples**](examples/) | small programs, plus a three-file market-prices app (`examples/v0.5/kasuwa/`) |

## Editor support

**VS Code**: syntax highlighting, live errors with their `DBR` code, completion, hover, formatting, run and
test — see [extension/](extension/README.md). Any editor that speaks the Language Server Protocol can run
`dabara lsp`.

## Playground

Try Dabara in a browser with nothing installed: see [playground/](playground/README.md).

## Something wrong?

Please [open an issue](../../issues) with the output of `dabara --version`, the program, and the message
(they start with a code like `[DBR-012]`). You do not need the source to report a bug.

## License

See [LICENSE](LICENSE): free to use and share the unmodified program; documentation and examples may be
copied and adapted. *(Draft terms — see the note at the top of the file.)*
