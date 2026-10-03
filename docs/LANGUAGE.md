# The Dabara Language — Reference

*Harshen Dabara.* This is the precise description of what Dabara programs mean: the vocabulary of
the language, how programs are written, and what every construct does. It is written for people who
**use** the language. Where the [User Guide](GUIDE.md) teaches by example, this page states the
rules. The word table is in [KEYWORDS.md](KEYWORDS.md).

Applies to **Dabara 0.6**. Every code block here is run against the real `dabara` program, and every
block followed by output shows the exact output it produces.

> **Provisional names.** The Hausa keyword and function names are proposals awaiting review by a
> committee of native speakers. Their *meaning* is stable; a name may still be changed (the old one
> stays as an alias for at least one release).

---

## 1. Source text

- A program is a UTF-8 text file, conventionally ending in `.ha`.
- A **comment** starts with `#` and runs to the end of the line. There are no block comments, and
  `//` is **not** a comment (`/` is division).
- Statements are separated by what they are, not by punctuation: one statement per line is the
  convention, and a statement may span lines inside brackets. There is no `;`.
- **Blocks** are written with braces: `{ … }`. Indentation has no meaning (the formatter,
  `dabara tsari`, uses two spaces).
- A program may optionally be wrapped in `fara` … `ƙare`. It makes no difference.

### 1.1 Identifiers and keywords

An identifier starts with a letter or `_` and continues with letters, digits, `_` and the apostrophe
`'` (so `nau'i` is one word). Letters include the Hausa hooked letters `ɓ ɗ ƙ ƴ` and `ʔ`. Names are
case-sensitive. Every hooked letter has an ASCII spelling for keyboards without it (`naɗa`/`nada`,
`ƙamus`/`kamus`, `karɓa`/`karba`).

Keywords cannot be used as variable names. The full list, with meanings, is in
[KEYWORDS.md](KEYWORDS.md). Two keywords are written with two words: `ci gaba` (also `ci_gaba`) and
`ko kuma` (else-if; `ammaidan` is the one-word form). A lone `ko` is the logical *or*.

### 1.2 Literals

| Literal | Examples | Notes |
|---|---|---|
| integer | `0` `42` `007` | 64-bit signed |
| float | `3.14` `0.5` | digits `.` digits; there is no exponent form |
| string | `"Sannu"` | double quotes only; may contain line breaks |
| boolean | `gaskiya` `karya` | true, false |
| nothing | `babu` | the absence of a value |
| list | `[1, "a", gaskiya]` | any mix of values |
| dictionary | `ƙamus { "suna": "Aisha", "shekaru": 23 }` | text keys, see §5.2 |

**String escapes:** `\n` `\t` `\r` `\0` `\"` `\\` and `\u{…}` (a Unicode code point in hex). Any other
backslash sequence is an error (`DBR-003`).

<!-- output -->
```hausa
rubuta "a\tb"
rubuta "ɗ\u{6b}"
rubuta "ta ce \"sannu\""
```
```text
a	b
ɗk
ta ce "sannu"
```

**Number limits.** An integer must fit in 64 bits: a literal that is too large is an error
(`DBR-031`, it is never silently changed), and arithmetic that leaves the range is an error
(`DBR-030`) rather than wrapping around. The smallest integer, −9223372036854775808, has no literal
of its own; write `-9223372036854775807 - 1`.

---

## 2. Values and types

Dabara is **dynamically typed**: variables have no declared type, values do. There is no static
type checker; a wrong combination is reported when the program runs.

| Type (`nau'i`) | Values | Counts as *false* when |
|---|---|---|
| `lambar` | integers | `0` |
| `lambar mai daɗewa` | floats | `0.0` (or not-a-number) |
| `jimla` | strings | empty |
| `gaskiya ko karya` | booleans | `karya` |
| `jerin abu` | lists | empty |
| `ƙamus` | dictionaries | empty |
| `babu` | nothing | always |
| `aiki` | functions | never (always true) |

Anywhere a condition is expected (`idan`, `maimaita`, `da`, `ko`, `ba`, `tabbatar`), **any** value
may be used and is judged by the column on the right.

<!-- output -->
```hausa
rubuta nau'i(1)
rubuta nau'i(1.5)
rubuta nau'i("a")
rubuta nau'i([1])
rubuta nau'i(ƙamus {})
rubuta nau'i(babu)
rubuta nau'i(gaskiya)
rubuta nau'i(aiki(x) { mayar x })
```
```text
lambar
lambar mai daɗewa
jimla
jerin abu
ƙamus
babu
gaskiya ko karya
aiki
```

Conversions are explicit functions: `lamba` (to integer), `ɓangare` (to float), `rubutu` (to string),
`jeri` (to list), `gaskiya_ko_karya` (to boolean).

<!-- output -->
```hausa
rubuta lamba("42") + 1
rubuta ɓangare("2.5") * 2
rubuta rubutu(7) + "!"
```
```text
43
5
7!
```

---

## 3. Expressions

### 3.1 Operators and precedence

From loosest to tightest binding:

| Level | Operators | Meaning |
|---|---|---|
| 1 | `ko` | logical or (short-circuit) |
| 2 | `da` | logical and (short-circuit) |
| 3 | `ba`, `!` | logical not |
| 4 | `==` `!=` | equality |
| 5 | `<` `>` `<=` `>=` | ordering |
| 6 | `+` `-` | addition, subtraction, string joining |
| 7 | `*` `/` `%` | multiplication, division, remainder |
| 8 | `-` (prefix) | negation |
| 9 | `.name(…)` `[…]` `(…)` | method call, index, call |

Binary operators of the same level group from the left. Parentheses override precedence.

<!-- output -->
```hausa
rubuta 1 + 2 * 3 - 4 / 2
rubuta (1 + 2) * 3
rubuta - 2 * 3
rubuta 3 > 2 da 2 > 1 ko karya
```
```text
5
9
-6
gaskiya
```

`da`, `ko` and `ba` always produce a boolean, and `da`/`ko` stop as soon as the answer is known: the
right-hand side of `karya da …` and `gaskiya ko …` is never evaluated.

<!-- output -->
```hausa
rubuta 0 ko "x"
rubuta karya da babu
rubuta ba gaskiya da karya
```
```text
gaskiya
karya
karya
```

(The last line is `(ba gaskiya) da karya`: `ba` binds tighter than `da`.)

### 3.2 Numbers

- Integer `+ - *` are exact; leaving the 64-bit range is `DBR-030`.
- Integer `/` **truncates toward zero**; `%` takes the sign of the left operand. Dividing by zero
  (`/` or `%`, integer or float) is `DBR-012`.
- If either operand is a float, the result is a float. Integers and floats compare by value, so
  `1 == 1.0`.

<!-- output -->
```hausa
rubuta 7 / 2
rubuta -7 / 2
rubuta 7.0 / 2
rubuta 7 % 3
rubuta -7 % 3
rubuta 7.5 % 2
rubuta 1 == 1.0
```
```text
3
-3
3.5
1
-1
1.5
gaskiya
```

### 3.3 Strings

- `+` **joins**. If *either* side is a string, the other side is converted to text first — numbers,
  booleans, lists, dictionaries, `babu` and functions all work. This is the only implicit conversion
  in the language.
- Strings compare with `==` and `!=`, and order alphabetically (by character code) with `< > <= >=`.
- Strings are sequences of characters (not bytes): `tsawo("Ƙasa")` is 4. `s[i]` is the one-character
  string at index `i` (negative counts from the end; out of range is `DBR-015`), and `s.yanki(a, b)`
  is the part from index `a` up to, not including, `b`. A string cannot be looped over with `ga`.

<!-- output -->
```hausa
rubuta "n = " + 5
rubuta 1 + 2 + "c"
rubuta "b" + 1 + 2
rubuta "a" < "b"
rubuta tsawo("Ƙasa")
```
```text
n = 5
3c
b12
gaskiya
4
```

<!-- output -->
```hausa
rubuta "abc"[1]
rubuta "abc"[-1]
naɗa s = "Ƙasa"
rubuta s[0]
rubuta s.yanki(1, 3)
```
```text
b
c
Ƙ
as
```

### 3.4 Equality

`==` compares by value. Lists compare element by element and dictionaries entry by entry (same keys,
same order). `babu` equals only `babu`, and may be compared with anything. Functions are equal only to
themselves. Inside a list or dictionary, entries of unrelated types are simply unequal.

<!-- output -->
```hausa
rubuta [1, 2] == [1, 2]
rubuta [1, [2]] == [1, [2]]
rubuta [1] == [1.0]
rubuta [1, "a"] == [1, 2]
rubuta ƙamus { "a": 1 } == ƙamus { "a": 1 }
rubuta babu == babu
rubuta babu == 0
```
```text
gaskiya
gaskiya
gaskiya
karya
gaskiya
gaskiya
karya
```

Comparing values of two *different basic types* directly — a string with a number, say — is an error
(`DBR-011`): convert one side first, with `lamba` or `rubutu`.

<!-- kuskure: DBR-011 -->
```hausa
rubuta "1" == 1
```

---

## 4. Statements

### 4.1 Variables

`naɗa name = value` creates a variable (`nada` and the older `var` mean the same). A bare
`name = value` — or `saita name = value` — **changes an existing variable**; assigning to a name that
was never created is an error. Elements are assigned the same way: `list[i] = v`, `dict["k"] = v`
(and nested, `grid[i][j] = v`).

<!-- output -->
```hausa
naɗa x = 5
x = x + 1
saita x = x * 2
rubuta x
naɗa l = [1, 2, 3]
l[0] = 10
rubuta l
```
```text
12
[10, 2, 3]
```

<!-- kuskure: DBR-010 -->
```hausa
y = 3
```

### 4.2 Output and input

`rubuta value` prints the value and a line break. Strings print without quotes; lists and dictionaries
print with their contents. `karɓa` (an expression) reads a line from the user.

### 4.3 Conditions

`idan condition { … }`, optionally followed by any number of `ko kuma condition { … }` (or
`ammaidan`) and finally `amma { … }`. The condition needs no parentheses.

<!-- output -->
```hausa
naɗa n = 0
idan n > 0 {
  rubuta "tabbatacce"
} ko kuma n < 0 {
  rubuta "korau"
} amma {
  rubuta "sifili"
}
```
```text
sifili
```

### 4.4 Loops

- `maimaita (condition) { … }` repeats while the condition holds. **The parentheses are required.**
- `ga item cikin collection { … }` runs the block once per element of a **list**, or once per **key**
  of a dictionary (in insertion order). Strings cannot be looped over directly.
- `katse` leaves the innermost loop; `ci gaba` skips to its next round. Using either outside a loop of
  the *same function* is an error (`DBR-022`).

<!-- output -->
```hausa
naɗa i = 0
maimaita (i < 5) {
  i = i + 1
  idan i == 2 { ci gaba }
  idan i == 4 { katse }
  rubuta i
}
ga k cikin ƙamus { "a": 1, "b": 2 } {
  rubuta k
}
```
```text
1
3
a
b
```

### 4.5 Errors: `gwada`, `kama`, `jefa`

`jefa value` raises any value as an error. `gwada { … } kama (name) { … }` runs the first block; if an
error is raised anywhere inside it (including inside functions it calls), execution continues in the
second block with the error in `name`.

- For `jefa`, `name` holds exactly the value thrown.
- For an error the language itself raised, `name` is a dictionary with `"lamba"` (the code, such as
  `"DBR-012"`) and `"saƙo"` (the message).
- `mayar`, `katse` and `ci gaba` pass straight through a `gwada` block.
- Both blocks are required; there is no `finally`.
- The recursion-depth error (`DBR-013`) cannot be caught.
- An error that nothing catches stops the program (`DBR-024` for a thrown value).

<!-- output -->
```hausa
gwada {
  jefa "matsala"
} kama (k) {
  rubuta "an kama: " + k
}
gwada {
  rubuta 1 / 0
} kama (k) {
  rubuta k["lamba"]
}
```
```text
an kama: matsala
DBR-012
```

---

## 5. Data

### 5.1 Lists

A list is an ordered, mixed collection. Indexing starts at `0`; a negative index counts from the end
(`-1` is the last element). An index outside the list is an error (`DBR-015`). `tsawo(list)` is its
length.

Lists are **values**: operations return a *new* list and leave the original unchanged. The dot-methods
are `.ƙara(x)` (a copy with `x` added), `.haɗa(sep)` (join into a string) and `.cire()` (the last
element). Put a list literal in a variable before calling a method on it. The helper functions
(`jera` sort, `juya` reverse, `tara` sum, `canza` map, `zaɓa` filter) are listed in
[KEYWORDS.md](KEYWORDS.md).

<!-- output -->
```hausa
naɗa l = [10, 20, 30]
rubuta l[0]
rubuta l[-1]
naɗa m = l.ƙara(40)
rubuta m
rubuta l
rubuta m.haɗa("-")
rubuta canza(l, aiki(x) { mayar x * 2 })
rubuta jera([3, 1, 2])
```
```text
10
30
[10, 20, 30, 40]
[10, 20, 30]
10-20-30-40
[20, 40, 60]
[1, 2, 3]
```

### 5.2 Dictionaries (`ƙamus`)

`ƙamus { "key": value, … }` maps text keys to values and remembers the order the keys were added.
`d["key"]` reads, `d["key"] = v` writes (adding the key if new). A numeric key is turned into text.
Reading a key that is not there is an error (`DBR-021`) — check first with `ƙunshi(d, "key")`.
`maɓallai(d)` lists the keys, `darajoji(d)` the values, `share(d, "key")` returns a copy without
that key, and `tsawo(d)` counts the entries.

<!-- output -->
```hausa
naɗa mutum = ƙamus { "suna": "Aisha", "shekaru": 23 }
mutum["birni"] = "Kano"
rubuta mutum["suna"]
rubuta ƙunshi(mutum, "birni")
rubuta ƙunshi(mutum, "waya")
rubuta maɓallai(mutum)
rubuta tsawo(mutum)
```
```text
Aisha
gaskiya
karya
[suna, shekaru, birni]
3
```

---

## 6. Functions

`aiki name(a, b) { … }` defines a function; `mayar value` returns from it. A function that finishes
without `mayar` returns `babu`. Calling with the wrong number of arguments is an error (`DBR-018`),
and calling something that is not a function is `DBR-023`.

**Functions are values.** `aiki(x) { … }` without a name makes an anonymous function, a function name
can be stored in a variable or passed as an argument, and a call can be followed by another call
(`f(1)(2)`).

**Scope is lexical.** A function sees the variables of the file it was written in (its *globals*),
the variables of the functions it is written inside, and its own — **never** the local variables of
whoever calls it. A function keeps the variables it was created with, even after the code that
created it has finished (a *closure*), and a closure's variables are shared between calls.

<!-- output -->
```hausa
aiki mai_ƙidaya() {
  naɗa ƙidaya = 0
  mayar aiki() {
    ƙidaya = ƙidaya + 1
    mayar ƙidaya
  }
}
naɗa a = mai_ƙidaya()
naɗa b = mai_ƙidaya()
a()
a()
rubuta a()
rubuta b()
aiki ba_komai() { }
rubuta ba_komai()
```
```text
3
1
babu
```

Functions may call themselves; the depth is limited (about ten thousand nested calls) and exceeding it
is an error (`DBR-013`) rather than a crash.

---

## 7. Files and programs

### 7.1 Modules: `shigo` and `fitar`

A program may be split over several files. In a module, `fitar aiki …` and `fitar naɗa …` (at the top
level of the file) **export** a function or a variable. Another file brings names in with
`shigo name1, name2 daga "path"`.

- The path is relative to the file that contains the `shigo`; `.ha` may be left off.
- A module runs **once**, the first time it is imported, and has **its own globals**: its variables
  never collide with the importer's, and its functions keep seeing their own module's variables
  wherever they are called from.
- Only exported names can be imported (`DBR-025` otherwise). An exported **variable is copied** at
  import time; to share changing state, export functions.
- Two files importing each other is an error (`DBR-026`); a missing file is `DBR-016`.
- Modules are available in the `dabara` command, not in the browser playground (`DBR-027`).

### 7.2 Files

`karanta_fayil(path)` returns a file's text, `rubuta_fayil(path, text)` creates or replaces a file,
`akwai_fayil(path)` tells whether it exists. A relative path is relative to the folder of the program
being run. A file that cannot be read or written is `DBR-016` (catchable). These work in the `dabara`
command only (`DBR-028` in the browser). `tsaga(text, sep)` splits text into a list, which is how a
file is turned into lines: `tsaga(karanta_fayil("farashi.txt"), "\n")`.

### 7.3 The `dabara` command

| Command | Does |
|---|---|
| `dabara file.ha` | run a program |
| `dabara sabo name` | create a project folder (`dabara.toml`, `main.ha`, `gwaji/`) |
| `dabara gudana [file]` | run a file, or the project's entry point |
| `dabara gwaji` | run the tests in `gwaji/`; exit code 1 if one fails |
| `dabara tsari [files] [--duba]` | format files (or only check with `--duba`) |
| `dabara lsp` | language server for editors |
| `dabara keywords --json` | the vocabulary, machine-readable |
| `dabara --version` | version and platform |
| `dabara --turanci …` | error category labels in English |

Tests are ordinary programs that stop with an error when something is wrong. `tabbatar(condition)` and
`tabbatar_daidai(got, expected)` raise `DBR-029` with both values in the message.

---

## 8. What the language does not have

By design, for now: static types, threads or asynchronous code, `finally`, looping over a string with
`ga … cikin` (loop over a list instead), classes, and a package manager. Programs that need them are not
expressible yet.

---

## 9. Error codes

Every error message starts with its code, `[DBR-nnn]`, so it can be searched for. The table of all
codes, with the message text and what causes each, is in section 11 of the [User Guide](GUIDE.md#11-understanding-error-messages).
