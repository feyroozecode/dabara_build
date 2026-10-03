# Dabara — User Guide

**Dabara** is a programming language with **Hausa keywords**, so you can learn to code in
your own language. This guide takes you from "hello world" to functions, loops, and the
standard library. For the exact rules, see the [language reference](LANGUAGE.md).

---

## 0. Sabuwa a v0.5 (What's new in v0.5)

- **`naɗa`** yanzu ita ce babbar kalma (mutanen da suka saba da `var` — `var` tana aiki har yanzu)
- **`fara` / `ƙare` ba dole ba ne** — zaka iya farawa da statements kai tsaye
- Duka **sunayen ayyuka Hausa ne**: `tsawo`, `jera`, `canza`, `zaɓa`, `tara`, `daraja`, `lamba`, `ɓangare`, `rubutu`... (Turanci suna aiki a matsayin alias)
- **Kuskure suna da lamba**: `[DBR-010]` — ka iya nema shi akan intanet. `--turanci` don Turanci
- Kwatance ta jimloli (`"a" < "b"`), `%` modulo, `da`/`ko`/`ba` — duka daga v0.3
- **v0.6**: `dabara sabo/tsari/gudana/gwaji/lsp` (§12.1), `tabbatar`, lists compare with `==`
- **v0.5**: `gwada`/`kama`/`jefa` (error handling, §7.8), `shigo`/`fitar` (modules, §7.9), files (§7.10), `ƙamus` (dictionaries), `babu` (nil), `maɓallai`, `darajoji`, `share` — aiki ba tare da `mayar` ba yana mayar da `babu`

Full keyword table: [KEYWORDS.md](KEYWORDS.md).

---

## 1. Your first program

Every Dabara program lives between `fara` (start) and `ƙare` (end). Save this as
`sannu.ha`:

```dabara
fara
    rubuta "Sannu Duniya!"
ƙare
```

Run it:

```bash
dabara sannu.ha
```

Output:

```
Sannu Duniya!
```

`rubuta` means **print**. Each `rubuta` writes one line.

> Tip: you can also run code in the **web playground** — nothing to install, it runs in your browser.
> (Modules and file functions only work in the `dabara` command, not in the playground.)

---

## 2. Variables

Use `naɗa` to create a variable (the ASCII spelling `nada` and the historical alias
`var` both still work). Names may use Hausa letters (`ɓ ɗ ƙ ƴ`).

```dabara
fara
    naɗa suna = "Ahmad"
    naɗa shekaru = 25
    naɗa tsayi = 1.75
    naɗa dalibi = gaskiya

    rubuta "Suna: " + suna
    rubuta "Shekaru: " + shekaru
ƙare
```

- `gaskiya` = **true**, `karya` = **false**.
- `+` joins (concatenates) strings, and can join a string with a number.

> `var` is an older word for `naɗa`. It still works but **`naɗa` is preferred**
> (primary as of v0.4).

---

## 3. Data types

| Type | Hausa name | Example |
|------|------------|---------|
| Whole number | `lambar` | `42` |
| Decimal | `lambar mai daɗewa` | `3.14` |
| Text | `jimla` | `"sannu"` |
| True/false | `gaskiya ko karya` | `gaskiya` |
| List | `jerin abu` | `[1, 2, 3]` |

Check a value's type with `type()`, and a length with `len()`:

```dabara
fara
    rubuta type(42)            # lambar
    rubuta type("sannu")       # jimla
    rubuta len("ƙarami")       # 6
    rubuta len([10, 20, 30])   # 3
ƙare
```

---

## 4. Math and operators

```dabara
fara
    naɗa a = 10
    naɗa b = 3
    rubuta a + b      # 13
    rubuta a - b      # 7
    rubuta a * b      # 30
    rubuta a / b      # 3   (whole-number division)
ƙare
```

| Operator | Meaning |
|----------|---------|
| `+ - * /` | add, subtract, multiply, divide |
| `%` | modulo — the remainder: `10 % 3` → `1` |
| `==` `!=` | equal, not equal |
| `<` `>` `<=` `>=` | comparisons (numbers *and* strings) |

Numbers and decimals mix freely; if any value is a decimal, the result is a decimal.
`1 == 1.0` is `gaskiya`. `"a" < "b"` sorts words alphabetically.

Strings can contain escapes: `"\n"` new line, `"\t"` tab, `\"` a quote, `\\` a
backslash, `"\u{263A}"` any Unicode character (`☺`).

---

## 5. Conditions: `idan`, `ko kuma`, `amma`

```dabara
fara
    naɗa maki = 75

    idan maki >= 80 {
        rubuta "Mai kyau sosai"
    } ko kuma maki >= 50 {
        rubuta "Ya wuce"
    } amma {
        rubuta "Bai wuce ba"
    }
ƙare
```

- `idan` = **if**
- `ko kuma` = **else if** (you may also see the older word `ammaidan`)
- `amma` = **else**

Combine conditions with Hausa logic words:

```dabara
fara
    naɗa shekaru = 20
    naɗa yana_da_ID = gaskiya

    idan shekaru > 18 da yana_da_ID {
        rubuta "Za ka iya shiga"
    }

    idan shekaru < 12 ko shekaru > 65 {
        rubuta "Fare ba za a biya ba"
    }

    idan ba yana_da_ID {
        rubuta "Ka je ka sami ID"
    }
ƙare
```

- `da` = **and** — both must be true
- `ko` = **or** — at least one must be true (but `ko kuma` = else if)
- `ba` (or `!`) = **not** — flips true/false

They bind tighter than `da`, which binds tighter than `ko`. `da` and `ko` stop early:
in `karya da (5 / 0)` the division never runs.

A condition is "true" when: a boolean is `gaskiya`, a number is non-zero, a string is
non-empty, or a list is non-empty.

---

## 6. Loops

### For-each: `ga … cikin …`

```dabara
fara
    naɗa lambobi = [1, 2, 3, 4, 5]
    ga n cikin lambobi {
        rubuta n
    }
ƙare
```

### While: `maimaita`

The condition needs parentheses — `maimaita` is the one control keyword that requires
them (`idan` and `ga` don't):

```dabara
fara
    naɗa i = 0
    maimaita (i < 3) {
        rubuta i
        naɗa i = i + 1
    }
ƙare
```

Control the loop with `katse` (**break**, stop the loop) and `ci_gaba` (**continue**, skip
to the next iteration):

```dabara
fara
    ga n cikin [1, 2, 3, 4, 5, 6] {
        idan n == 4 {
            katse
        }
        rubuta n        # prints 1 2 3
    }
ƙare
```

---

## 7. Functions: `aiki` and `mayar`

Define with `aiki`, return a value with `mayar`.

```dabara
fara
    aiki gaisuwa(suna) {
        mayar "Sannu " + suna
    }

    aiki tara(a, b) {
        mayar a + b
    }

    rubuta gaisuwa("Amina")     # Sannu Amina
    rubuta tara(3, 4)           # 7
ƙare
```

Functions can call other functions and use the standard library:

```dabara
fara
    aiki nisa(x1, y1, x2, y2) {
        naɗa dx = x2 - x1
        naɗa dy = y2 - y1
        mayar sqrt(pow(dx, 2) + pow(dy, 2))
    }
    rubuta nisa(0, 0, 3, 4)     # 5
ƙare
```

---

## 7.5 Ƙamus: ƙamus da babu (dictionaries and nil)

A `ƙamus` stores named values — like a word in a real dictionary:

```dabara
naɗa mutum = ƙamus { "suna": "Aisha", "shekaru": 23, "birni": "Zinder" }

rubuta mutum["suna"]        # Aisha
mutum["shekaru"] = 24       # canza (update)
mutum["aure"] = "a'a"       # ƙara sabon maɓalli (add a new key)

rubuta mutum                # {"suna": "Aisha", "shekaru": 24, "birni": "Zinder", "aure": "a'a"}
rubuta tsawo(mutum)         # 4
```

Walk over the keys with `ga..cikin`, and use the helpers:

```dabara
naɗa mutum = ƙamus { "suna": "Aisha", "shekaru": 24, "birni": "Zinder" }

ga k cikin mutum {
    rubuta k + " = " + mutum[k]
}

rubuta maɓallai(mutum)          # jerin maɓallai (list of keys)
rubuta darajoji(mutum)          # jerin darajoji (list of values)
rubuta ƙunshi(mutum, "birni")   # gaskiya — shine maɓalli ne? (has key?)
rubuta share(mutum, "birni")    # sabon ƙamus ba tare da "birni" ba
```

Reading a missing key is an error (`DBR-021`), so check first with `ƙunshi`.

**`babu`** means "there is nothing". A function that ends without `mayar`
returns `babu` — and `babu` is not `0`:

```dabara
naɗa kasuwa = ƙamus { "shinkafa": 500, "masara": 300 }

aiki nemi(kasuwa, kaya) {
    idan ƙunshi(kasuwa, kaya) {
        mayar kasuwa[kaya]
    }
}

rubuta nemi(kasuwa, "wake") == babu    # gaskiya
rubuta babu == 0                        # karya
```

## 7.6 Aiki a matsayin ƙima (functions as values)

Functions are values now. Bind one to a name, pass it, return it:

```dabara
aiki ninka_biyu(n) { mayar n * 2 }
naɗa f = ninka_biyu
rubuta f(21)                     # 42
```

Anonymous functions (`aiki` without a name) go straight in as arguments:

```dabara
naɗa farashi = [1200, 800, 2500]
rubuta canza(farashi, aiki(f) { mayar f + 100 })   # [1300, 900, 2600]
rubuta zaɓa(farashi, aiki(f) { mayar f > 1000 })   # [1200, 2500]
```

You can even call the result of a call:

```dabara
naɗa kawo = aiki(x) { mayar aiki(y) { mayar x * 10 + y } }
rubuta kawo(3)(4)                # 34
```

## 7.7 Fermeture (closures)

An inner function remembers the variables of the place it was born — and
changes to them **persist**:

```dabara
aiki mai_ƙidaya() {
    naɗa ƙidaya = 0
    mayar aiki() {
        ƙidaya = ƙidaya + 1
        mayar ƙidaya
    }
}

naɗa gaba = mai_ƙidaya()
gaba()
gaba()
rubuta gaba()     # 3 — ana tuna yanayin (state is remembered)
```

Two counters made from the same maker stay independent. One rule: `katse`
and `ci gaba` work only inside `maimaita`/`ga` **of the same function** —
using one inside a closure called from a loop is an error (`DBR-022`).

## 7.8 Kuskure: `gwada` / `kama` / `jefa` (error handling)

`gwada` (*try*) runs a block; if anything goes wrong, `kama` (*catch*) receives it
instead of the program stopping. `jefa` (*throw*) raises any value yourself.

```hausa
aiki raba(a, b) {
    idan b == 0 {
        jefa "ba a raba da sifili"
    }
    mayar a / b
}

gwada {
    rubuta raba(10, 2)
    rubuta raba(1, 0)
    rubuta "ba a kai nan ba"
} kama (k) {
    rubuta "an kama: " + k
}
```

Output: `5` then `an kama: ba a raba da sifili`. The rest of the `gwada` block is skipped.

- `jefa` takes any value (text, number, `ƙamus`…); `k` is exactly that value.
- **Runtime errors are caught too.** Then `k` is a `ƙamus` with `"lamba"` (the `DBR-xxx` code)
  and `"saƙo"` (the message without the line number):

```hausa
gwada {
    rubuta 5 % 0
} kama (k) {
    rubuta k["lamba"]   # DBR-012
    rubuta k["saƙo"]    # Ba za a iya raba da sifili ba
}
```

- `mayar`, `katse` and `ci gaba` pass straight through `gwada`; they are not errors.
- A `jefa` nobody catches stops the program with `DBR-024`.
- **`DBR-013` (recursion too deep) cannot be caught** — catching it would let a runaway
  function retry forever.
- Both `gwada { }` and `kama (k) { }` are required; there is no `finally` in v0.5.

## 7.9 Fayiloli da yawa: `shigo` / `fitar` (modules)

Split a program across files. A file shares only what it marks with `fitar`
(*export*); another file brings it in with `shigo … daga` (*import … from*).

`lissafi.ha`:
<!-- file: lissafi.ha -->
```hausa
fitar naɗa PI = 3
naɗa ƙidaya = 0                      # sirri — ba a fitar da shi ba (private)

aiki taimako(x) {                    # sirri
    ƙidaya = ƙidaya + 1
    mayar x * 2 + PI
}
fitar aiki biyu(x) { mayar taimako(x) }
fitar aiki yawa() { mayar ƙidaya }
```

`main.ha`:
```hausa
shigo biyu, yawa, PI daga "./lissafi"
rubuta biyu(5)     # 13
rubuta biyu(1)     # 5
rubuta yawa()      # 2 — module state is remembered
rubuta PI          # 3
```

Rules:
- The path is **relative to the file that contains the `shigo`**; `.ha` is optional.
- A module runs **once**, the first time anyone imports it, in **its own global scope**:
  its variables never collide with yours, and its functions keep seeing *its* globals even
  when you call them (or pass them your own functions as callbacks).
- Only `fitar aiki …` and `fitar naɗa …` at the top level of a file can be exported.
  Importing a name that was not exported is `DBR-025`.
- An exported **variable is a copy** taken at import time. To share changing state, export
  functions (like `yawa()` above).
- Two files importing each other is `DBR-026`; the message shows the chain
  (`a.ha → b.ha → a.ha`). A missing file is `DBR-016`.
- Import errors can be caught with `gwada`/`kama` (§7.8).
- `shigo` works in the command-line `dabara`, **not** in the browser playground (`DBR-027`).

## 7.10 Fayiloli: `karanta_fayil` / `rubuta_fayil` (reading and writing files)

```hausa
rubuta_fayil("gaisuwa.txt", "Sannu\nDuniya")
rubuta akwai_fayil("gaisuwa.txt")                  # gaskiya
naɗa abun = karanta_fayil("gaisuwa.txt")
ga layi cikin tsaga(abun, "\n") { rubuta layi }    # Sannu / Duniya
```

- `karanta_fayil(hanya)` returns the whole file as text; `rubuta_fayil(hanya, rubutu)` creates
  or overwrites it (returns `babu`); `akwai_fayil(hanya)` is `gaskiya`/`karya`.
- **Relative paths are relative to the folder of the program you ran** (the same base as
  `shigo`), not to wherever your terminal happens to be.
- A file that cannot be read or written is `DBR-016` — catch it with `gwada`/`kama` (§7.8).
- `tsaga(rubutu, mai_raba)` splits text into a list (`""` splits into characters).
- Files work in the command-line `dabara` only; in the browser playground they fail with `DBR-028`.

A complete multi-file program using modules, `ƙamus`, closures, `gwada` and files lives in
`examples/v0.5/kasuwa/` — run `dabara examples/v0.5/kasuwa/main.ha`.

## 8. Lists

```dabara
fara
    naɗa lambobi = [10, 20, 30]
    rubuta lambobi[0]            # 10  (first item, index starts at 0)
    rubuta lambobi[-1]           # 30  (negative index counts from the end)
    rubuta tsawo(lambobi)        # 3
ƙare
```

> An apostrophe works **inside** an identifier (`nau'i` lexes as one word), but not as
> the **first** character — `'ya'ya` (children) fails to lex. Track this if you're
> writing real Hausa words that start with the glottal-stop apostrophe.

List helpers (these **return a new value** — assign the result back):

```dabara
fara
    naɗa jeri = [3, 1, 2]
    naɗa sabo = jeri.ƙara(4)    # [3, 1, 2, 4]
    rubuta sum([1, 2, 3, 4])   # 10
    rubuta jeri.haɗa(", ")     # "3, 1, 2"
ƙare
```

---

## 9. Strings

```dabara
fara
    naɗa s = "Sannu Duniya"
    rubuta s.tsawo             # 12  (length)
    rubuta s.babba             # SANNU DUNIYA  (uppercase)
    rubuta s.ƙarami            # sannu duniya  (lowercase)
    rubuta s.yanki(0, 5)       # "Sannu"  (substring)
    rubuta contains(s, "Duniya")   # gaskiya
ƙare
```

---

## 10. Built-in function reference

Since v0.4 every function has a **Hausa primary name**; the English name still works as
an alias (so old code and search-engine muscle memory both keep working). Call these
like `saiwa(16)` — or `sqrt(16)`, same function. Full table (Hausa / English):

### Math
`daraja(x)`/`abs(x)` `saiwa(x)`/`sqrt(x)` `pow(base, exp)` `mafi_ƙanƙanta(a, b)`/`min(a, b)`
`mafi_girma(a, b)`/`max(a, b)` `ƙasa(x)`/`floor(x)` `sama(x)`/`ceil(x)` `kewaya(x)`/`round(x)`
`sin(x)` `cos(x)` `tan(x)` `asin(x)` `acos(x)` `atan(x)`

> `pow` and the trig functions keep their English names for now — pending the naming
> committee (Kwamitin Harshe).

### Type conversion
`lamba(x)`/`int(x)` `ɓangare(x)`/`float(x)` `rubutu(x)`/`string(x)` `jeri(x)`/`list(x)`
`gaskiya_ko_karya(x)`/`bool(x)`

### Strings
`ƙunshi(text, part)`/`contains(text, part)` `fara_da(text, prefix)`/`starts_with(text, prefix)`
`ƙare_da(text, suffix)`/`ends_with(text, suffix)` `maye(text, old, new)`/`replace(text, old, new)`
`datse(text)`/`trim(text)` `tsaga(text, sep)`/`split(text, sep)` → list; `karanta_fayil`/`rubuta_fayil`/`akwai_fayil` (§7.10)

### Lists
`jera(list)`/`sort(list)` `juya(list)`/`reverse(list)` `tara(list)`/`sum(list)`
`canza(list, f)`/`map(list, f)` `zaɓa(list, f)`/`filter(list, f)`

`canza`/`map` and `zaɓa`/`filter` take `f` as either the name of one of your functions
**as text** (in quotes), or — since v0.5 — a **function value** directly, including an
anonymous `aiki`:

```dabara
fara
    aiki ninka2(x) {
        mayar x * 2
    }
    aiki manya(x) {
        mayar x > 2
    }
    rubuta canza([1, 2, 3], "ninka2")           # [2, 4, 6] — by name (works since v0.4)
    rubuta canza([1, 2, 3], ninka2)             # [2, 4, 6] — by function value (v0.5)
    rubuta zaɓa([1, 2, 3, 4], manya)            # [3, 4]
    rubuta canza([1, 2, 3], aiki(x) { mayar x + 1 })   # [2, 3, 4] — anonymous aiki (v0.5)
ƙare
```

### Dictionaries (v0.5)
`maɓallai(m)`/`maballai(m)`/`keys(m)` → list of keys &nbsp;·&nbsp;
`darajoji(m)`/`values(m)` → list of values &nbsp;·&nbsp;
`share(m, key)`/`delete(m, key)` → new dict without `key` &nbsp;·&nbsp;
`ƙunshi(m, key)`/`contains(m, key)` → has-key (same function as string `ƙunshi`,
dispatches on the first argument's type). See §7.5 above for worked examples.

### Core
`nau'i(x)`/`type(x)` → the value's Hausa type name &nbsp;·&nbsp;
`tsawo(x)`/`len(x)` → length of a string, list, or dict (v0.5: dict counts entries)

### Methods (call with `.`)
| On | Method | Does |
|----|--------|------|
| text | `.tsawo` | length |
| text | `.babba` | UPPERCASE |
| text | `.ƙarami` | lowercase |
| text | `.yanki(a, b)` | substring from `a` to `b` |
| text | `.raba(sep)` | split into a list |
| list | `.tsawo` | length |
| list | `.ƙara(x)` | new list with `x` added |
| list | `.cire` | the last item (removes it) |
| list | `.haɗa(sep)` | join into text |

---

## 11. Understanding error messages

All errors are in Hausa, prefixed by the kind:

| Prefix | Means | Example |
|--------|-------|---------|
| `Kuskure na Tokenization` | unknown character | `Ba a gane kalmar '@'` |
| `Kuskure na Syntax` | something is written wrong | `Ana tsammanin '{', amma an samu 'rubuta'` |
| `Kuskure na Runtime` | error while running | `Ba za a iya raba da sifili ba` (divide by zero) |

Every error also carries a **searchable code** (`[DBR-xxx]`, v0.4). Run with
`--turanci` for English category labels. The code index:

| Code | Hausa hint | Meaning |
|------|-----------|---------|
| `DBR-001` | Ba a gane kalmar | unknown character/word |
| `DBR-002` | Babu ƙarshen jimla | missing closing quote |
| `DBR-003`/`DBR-004` | salon kubba | bad escape (`\q`, `\u{...}`) |
| `DBR-005` | Ana tsammanin '…' | unexpected token (syntax) |
| `DBR-006`–`DBR-009` | Ana tsammanin statement/expression/suna/jimla | expected statement/expression/name/string |
| `DBR-010` | Babu irin wannan mai canjin | variable not declared |
| `DBR-011` | Ba za a iya amfani da '…' | invalid operation for these types |
| `DBR-012` | raba da sifili | divide/modulo by zero |
| `DBR-013` | Aikin ya yi zurfi sosai | recursion depth limit |
| `DBR-014` | *(retired)* | was the `shigo`/`fitar` stub before v0.5; the number is never reused |
| `DBR-015` | Lamba ya wuce iyaka | index out of bounds |
| `DBR-016` | Ba za a iya samun fayil | file not found |
| `DBR-017` | Aiki '…' ba a gani ba | calling an undefined function |
| `DBR-018` | yana buƙatar N argument(s) | wrong number of arguments |
| `DBR-019` | kuskure na gaba ɗaya | other runtime error |
| `DBR-020` | Ba za a iya sanya maka a nan ba | invalid assignment target |
| `DBR-021` | Maɓalli '…' ba a gani ba | missing key in a `ƙamus` (v0.5) |
| `DBR-022` | 'katse' yana iya aiki a cikin 'maimaita' ko 'ga' kawai | break/continue outside a loop (v0.5) |
| `DBR-023` | Ba za a iya kira … ba | calling something that is not a function (v0.5) |
| `DBR-024` | An jefa kuskure ba a kama shi ba | `jefa` with no enclosing `gwada` (v0.5) |
| `DBR-025` | '…' ba a fitar da shi daga '…' ba | `shigo` of a name the module did not `fitar`; or `fitar` inside a function (v0.5) |
| `DBR-026` | Zagayen shigo tsakanin fayiloli | import cycle, with the chain (v0.5) |
| `DBR-027` | 'shigo' ba ya aiki a cikin burauza | modules in the browser playground (v0.5) |
| `DBR-028` | Ayyukan fayil ba sa aiki a cikin burauza | file functions in the browser playground (v0.5) |
| `DBR-029` | Tabbatarwa ta gaza | `tabbatar` / `tabbatar_daidai` failed (v0.6) |
| `DBR-030` | Lamba ta yi girma sosai | integer overflow — result does not fit in 64 bits (v0.6) |
| `DBR-031` | Lambar … ta yi girma da yawa | number literal too large to store (v0.6) |

Every error points at **where** it happened: `a layi 4, shafi 9` means *"line 4, column 9"*
(runtime errors show the line, e.g. `a layi 3`). For example:

```
Kuskure na Syntax: Ana tsammanin '{', amma an samu 'rubuta' (a layi 4, shafi 9)
```

> The syntax message `Ana tsammanin 'X', amma an samu 'Y'` means *"expected X, but found
> Y"* — it is about **grammar**, not types. (Dabara checks types only while running.)

A runtime type mismatch looks like:

```
Kuskure na Runtime: Ba za a iya amfani da 'rage' tsakanin jimla da lambar
```

…meaning you tried to subtract (`rage`) a number from text (`jimla`).

---

## 12. Comments and style

```dabara
fara
    # This is a comment — ignored when running
    naɗa x = 5      # comments can follow code too
ƙare
```

- One statement per line.
- Indentation is for humans (Dabara doesn't require it) — but please indent.
- End the file with `ƙare`.

---

## 12.1 Projects and tools: `sabo`, `gudana`, `gwaji`, `tsari`

```sh
dabara sabo gwajiApp        # create a project (sabo = new)
cd gwajiApp
dabara gudana               # run it (gudana = run) — reads `fara` in dabara.toml
dabara gwaji                # run every file in gwaji/ (gwaji = test)
dabara tsari                # format every .ha file (tsari = arrange)
```

`dabara sabo` creates:

```
gwajiApp/
├── dabara.toml          # the manifest
├── main.ha              # entry point: rubuta "Sannu, Duniya!"
└── gwaji/gwaji_farko.ha # a first test
```

The manifest is three lines — Hausa keys, English aliases (`name`, `version`, `main`) also work:

```toml
[project]
suna  = "gwajiApp"   # name
sigar = "0.1.0"      # version
fara  = "main.ha"    # entry point
```

- `dabara gudana` and `dabara gwaji` work from **any folder inside** the project. `dabara file.ha`
  and `dabara gudana file.ha` still run a single file anywhere.
- **`dabara gwaji`** runs each file in `gwaji/` in its own process. A test **fails** when the
  program stops with an error — for example an uncaught `jefa "…"` (§7.8). The summary is in
  Hausa (`2 sun yi nasara, 1 sun faɗi`) and the exit code is 1 if anything failed.
- **`dabara tsari`** formats files in place; `dabara tsari --duba` only checks (exit 1 if a file
  would change — good for CI); `dabara tsari a.ha folder/` formats just those. The style is fixed:
  2-space indent, one space around operators and after commas, at most one blank line in a row.
  Comments and line breaks are kept. If the formatter cannot prove it left your program's
  meaning unchanged, it **does not write the file** and tells you (`an tsallake`).

### Writing tests: `tabbatar` and `tabbatar_daidai`

Put `.ha` files in `gwaji/`. A test fails when it stops with an error; the two assertion
functions make that easy:

```hausa
aiki ninka(a, b) { mayar a * b }

tabbatar_daidai(ninka(6, 7), 42)                    # (samu, an sa ran) — got, expected
tabbatar_daidai([1, 2] , [1, 2])                    # lists compare element by element
tabbatar(ninka(2, 2) == 4, "2 × 2 ya kamata ya zama 4")
rubuta "PASS — ninka"
```

When one fails, `dabara gwaji` shows the file, the line and both values:

<!-- kuskure: DBR-029 -->
```hausa
tabbatar_daidai(2 * 3, 7, "ninka")
```

```
  ❌ gwaji/lissafi.ha
       Kuskure na Runtime: [DBR-029] Tabbatarwa ta gaza: an samu 6, an sa ran 7 — ninka (a layi 2)
```

- `tabbatar(sharaɗi [, saƙo])` fails unless `sharaɗi` is truthy (same rule as `idan`).
- `tabbatar_daidai(samu, an_sa_ran [, saƙo])` uses `==`: `1` equals `1.0`, `babu` equals only
  `babu`, a `jimla` never equals a `lambar`.
- A failed assertion is an ordinary error (`DBR-029`), so `gwada`/`kama` can catch it.

### Editor support: `dabara lsp`

`dabara lsp` starts a language server on stdin/stdout for any editor that speaks LSP. It gives
**error squiggles** (syntax errors with their `DBR-xxx` code), **completion** for every keyword
and function, and **hover** text from `docs/KEYWORDS.md`. It does not do go-to-definition yet.

## 13. Where to next

- **The exact rules**: [LANGUAGE.md](LANGUAGE.md)
- **Every keyword and function**: [KEYWORDS.md](KEYWORDS.md)
- **What changed in each version**: [RELEASE_NOTES.md](RELEASE_NOTES.md)
- **Example programs**: the `examples/` folder — small programs, and a three-file app in `examples/v0.5/kasuwa/`

Barka da koyo! (Happy learning!)
