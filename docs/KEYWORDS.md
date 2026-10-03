# Dabara — Keyword & Standard-Library Table

> **Single source of truth.** The language itself, the documentation, the editor
> extension (highlighting, completion, hover) and the playground all agree with this table.
>
> **Status: PROVISIONAL** — these Hausa names are proposals awaiting
> ratification by the **Kwamitin Harshe** (3–5 native speakers, Niger and
> Nigeria, at least one teacher). Naming is the one irreversible decision in
> the roadmap; nothing is removed until the committee signs off. If the
> committee renames something, the old name stays as an alias for one minor
> release.

Rules (v0.4):

1. **Hausa is primary; English is at most an alias.** Both always work.
2. **Every hooked character has an ASCII alias** (`ƙ ɓ ɗ ƴ` are not on a
   standard phone keyboard in Niamey or Kano).
3. **Two-word keywords are allowed**: `ci gaba` and `ci_gaba` are the same
   token; `ko kuma` = else-if while bare `ko` = or.
4. Standard (Kano) Hausa base; Niger usage accepted as aliases where it diverges.

---

## 1. Keywords

| Meaning | Primary (Hausa) | ASCII alias | Legacy alias | Token | Status |
|---|---|---|---|---|---|
| program start | `fara` | — | — | Begin | stable |
| program end (optional since v0.4) | `ƙare` | `kare` | — | End | stable |
| print | `rubuta` | — | — | Print | stable |
| declare variable | `naɗa` | `nada` | `var` | Let | **renamed primary v0.4** |
| function | `aiki` | — | — | Function | stable |
| return | `mayar` | — | — | Return | stable |
| user input | `karɓa` | `karba` | — | Input | alias added v0.4 |
| if | `idan` | — | — | If | stable |
| else | `amma` | — | — | Else | stable |
| else if | `ammaidan` / `ko kuma` | — | — | ElseIf | stable |
| while | `maimaita` | — | — | While | stable |
| for…in | `ga` … `cikin` | — | — | For / In | stable |
| break | `katse` | — | — | Break | stable |
| continue | `ci gaba` | `ci_gaba` | — | Continue | two-word added v0.4 |
| explicit assign | `saita` | — | — | Set | stable |
| **and** | `da` | — | — | And | v0.3 |
| **or** | `ko` | — | — | Or | v0.3 |
| **not** | `ba` / `!` | `!` | — | Not | v0.3 |
| true / false | `gaskiya` / `karya` | — | — | True / False | stable |
| dictionary literal (v0.5) | `ƙamus` | `kamus` | — | Dict | **v0.5** |
| nil / absence (v0.5) | `babu` | — | — | Nil | **v0.5**; falsy, distinct from `0` |
| try (v0.5) | `gwada` | — | — | Try | **v0.5 S3a**, provisional (G1) |
| catch (v0.5) | `kama` | — | — | Catch | **v0.5 S3a**, provisional (G1) |
| throw (v0.5) | `jefa` | — | — | Throw | **v0.5 S3a**, provisional (G1) |
| import | `shigo` | — | — | Import | **v0.5 S3b**: `shigo a, b daga "./fayil"` |
| export | `fitar` | — | — | Export | **v0.5 S3b**: prefix of `aiki` / `naɗa`; REPL exit command is now `fita` (`fitar` still accepted there) |
| from (module) | `daga` | — | — | From | **v0.5 S3b** |

Operators: `+ - * / %` `== != < > <= >=` `=` — symbols only; the old Hausa
operator keywords (`ƙara`, `rage`, `ninka`, `raba`) were removed before v0.2 to
avoid conflicts with method names.

---

## 2. Standard library

Hausa primary; the English name is a permanent alias. **Provisional names**
pending Kwamitin Harshe.

### Core

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| length | `tsawo` | — | `len` | **v0.4** |
| kind / type of value | `nau'i` | `nauri` | `type` | **v0.4** (apostrophe form) |

### Math

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| absolute value | `daraja` | — | `abs` | **v0.4** |
| square root | `saiwa` | — | `sqrt` | **v0.4** |
| power | — | — | `pow` | pending Hausa name |
| smallest | `mafi_ƙanƙanta` | `mafi_kankanta` | `min` | **v0.4** |
| largest | `mafi_girma` | — | `max` | **v0.4** |
| round down | `ƙasa` | `kasa` | `floor` | **v0.4** |
| round up | `sama` | — | `ceil` | **v0.4** |
| round nearest | `kewaya` | — | `round` | **v0.4** |
| sin/cos/tan/asin/acos/atan | — | — | `sin` … | pending Hausa names |
| constants | — | — | `DABARAN_PI`, `DABARAN_E` | stable |

### Type conversion

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| to number | `lamba` | — | `int` | **v0.4** |
| to decimal | `ɓangare` | `bangare` | `float` | **v0.4** |
| to string | `rubutu` | — | `string` | **v0.4** |
| to list | `jeri` | — | `list` | **v0.4** (provisional) |
| to boolean | `gaskiya_ko_karya` | — | `bool` | **v0.4** |

### Strings

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| contains | `ƙunshi` | `kunshi` | `contains` | **v0.4** |
| starts with | `fara_da` | — | `starts_with` | **v0.4** |
| ends with | `ƙare_da` | `kare_da` | `ends_with` | **v0.4** |
| replace | `maye` | — | `replace` | **v0.4** |
| trim | `datse` | — | `trim` | **v0.4** |
| split (v0.5) | `tsaga(rubutu, mai_raba)` | — | `split` | **v0.5 S3c**, provisional (G1) |
| read file (v0.5) | `karanta_fayil(hanya)` | — | `read_file` | **v0.5 S3c**, provisional (G1); CLI only |
| write file (v0.5) | `rubuta_fayil(hanya, rubutu)` | — | `write_file` | **v0.5 S3c**, provisional (G1); CLI only |
| file exists (v0.5) | `akwai_fayil(hanya)` | — | `file_exists` | **v0.5 S3c**, provisional (G1); CLI only |

### Lists

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| arrange in order | `jera` | — | `sort` | **v0.4** |
| turn around | `juya` | — | `reverse` | **v0.4** |
| gather / total | `tara` | — | `sum` | **v0.4** |
| choose | `zaɓa` | `zaba` | `filter` | **v0.4**; accepts a name-as-text or a function value (v0.5) |
| transform | `canza` | — | `map` | **v0.4**; accepts a name-as-text or a function value (v0.5) |

### Testing (v0.6)

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| assert truthy: `tabbatar(sharaɗi [, saƙo])` | `tabbatar` | — | `assert` | **v0.6 S2**, provisional (G1) |
| assert equal: `tabbatar_daidai(samu, an_sa_ran [, saƙo])` | `tabbatar_daidai` | — | `assert_eq` | **v0.6 S2**, provisional (G1) |

### Dictionaries (v0.5)

| Meaning | Hausa primary | ASCII alias | English alias | Status |
|---|---|---|---|---|
| list of keys | `maɓallai` | `maballai` | `keys` | **v0.5** |
| list of values | `darajoji` | — | `values` | **v0.5** |
| new dict without a key | `share` | — | `delete` | **v0.5** |
| has-key | `ƙunshi` | `kunshi` | `contains` | shares the string `ƙunshi`/`contains` function (§Strings above), dispatches on arg 1's type |
| entry count | `tsawo` | — | `len` | shares the core `tsawo`/`len` function (§Core above) |

### Methods (dot-call)

Called on a **variable or a string**; they return a new value and never change the receiver.
(A list *literal* cannot be the receiver — put it in a variable first: `naɗa l = [1, 2]` then `l.ƙara(3)`.)

| On | Method | Result |
|---|---|---|
| `jimla` (string) | `.tsawo()` | number of characters |
| | `.babba()` / `.ƙarami()` (`.karami()`) | upper / lower case |
| | `.yanki(a, b)` | the characters from index `a` up to (not including) `b` |
| | `.raba(sep)` | list of parts split at `sep` |
| `jeri` (list) | `.ƙara(x)` (`.kara(x)`) | a new list with `x` added at the end |
| | `.haɗa(sep)` (`.hada(sep)`) | one string, items joined by `sep` |
| | `.cire()` | the last element (the list itself is unchanged) |
