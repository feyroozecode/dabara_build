# Sprint 2 — "Masu Aiki" (operators)
# D3: da / ko / ba — masu aiki na gargajiya da gajeriyar hanya (short-circuit).
# D4: % modulo, cikakke ga lambobi da ɓangare (float).
# (Every line should print PASS. FAIL would mean a fix regressed.)

fara

    # D3 — teburin gaskiya na da
    rubuta "D3 da:"
    idan gaskiya da gaskiya {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }
    idan ba (gaskiya da karya) {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D3 — teburin gaskiya na ko
    rubuta "D3 ko:"
    idan karya ko gaskiya {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }
    idan ba (karya ko karya) {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D3 — ba (not) da ! suna daidaita
    rubuta "D3 ba/!:"
    var g = gaskiya
    idan ba karya da !karya da (ba g == karya) {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D3 — gajeriyar hanya: raba da sifili ba za a taba aiwatarwa ba
    rubuta "D3 short-circuit:"
    idan karya da (5 / 0) {
        rubuta "FAIL"
    } amma {
        rubuta "PASS"
    }
    idan gaskiya ko (5 / 0) {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D3 — precedence: ba > da > ko, kuma kwatance ta fi su daure
    rubuta "D3 precedence:"
    var shekaru = 20
    var yana_da_ID = gaskiya
    idan shekaru > 18 da yana_da_ID {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }
    idan shekaru < 12 ko shekaru > 65 {
        rubuta "FAIL"
    } amma {
        rubuta "PASS"
    }

    # D4 — modulo na lambobi
    rubuta "D4 % na lambobi:"
    idan 10 % 3 == 1 da 20 % 5 == 0 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D4 — modulo na ɓangare (float)
    rubuta "D4 % na ɓangare:"
    idan 10.5 % 3 == 1.5 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D4 — amfani na yau da kullum: maimaita ko ba a maimaita ba (even/odd)
    rubuta "D4 maimaita/ba a maimaita ba:"
    ga n cikin [1, 2, 3, 4] {
        idan n % 2 == 0 {
            rubuta "maimaita"
        } amma {
            rubuta "ba a maimaita ba"
        }
    }

ƙare
