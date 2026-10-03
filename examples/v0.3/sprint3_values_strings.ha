# Sprint 3 — "Kima da Jimloli" (values & strings)
# D5: kubba a cikin jimloli (\n \t \" \\ \u{XXXX}).
# D6: 1 == 1.0 — kwatance tsakanin lamba da ɓangare.
# D7: jerin jimloli ta haruffa ("a" < "b").
# (Every line should print PASS. FAIL would mean a fix regressed.)

fara

    # D5 — kubba: sabon layi, shafi, kubba, backslash
    rubuta "D5 kubba a jimloli:"
    rubuta "1\t2\t3"
    rubuta "Ya ce \"sannu\" duka"
    rubuta "Hanya: C:\\dabara"

    # D5 — \u{XXXX} yana kawo harafin Unicode
    rubuta "D5 unicode escape:"
    rubuta "Dabara \u{1F60A}"
    rubuta "Hausa: \u{0199}\u{0253}\u{0257}"   # ƙ ɓ ɗ

    # D6 — kwatance daidai tsakanin lamba da ɓangare
    rubuta "D6 lamba da ɓangare suna daidai:"
    idan 1 == 1.0 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }
    idan 2.0 != 3 da 2.0 == 2 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D7 — jerin jimloli (lexicographic order)
    rubuta "D7 jerin jimloli:"
    idan "a" < "b" da "musa" > "aisha" da "a" >= "a" {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D7 — jera sunaye (sort a v0.3; sunan Hausa `jera` zai zo a v0.4)
    rubuta "D7 jera sunaye:"
    var sunaye = ["Zainab", "Aisha", "Musa", "Ibrahim"]
    ga s cikin sort(sunaye) {
        rubuta s
    }

    # Duka tare: Ƙidaya sunaye waɗanda suka fi "M" a jerin haruffa
    var fiye = 0
    ga s cikin sunaye {
        idan s > "M" {
            fiye = fiye + 1
        }
    }
    idan fiye == 2 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

ƙare
