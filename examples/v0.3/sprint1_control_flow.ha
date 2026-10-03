# Sprint 1 — "Harkokin Sarrafawa" (control flow honesty)
# D1: katse / ci_gaba / mayar yanzu suna tsayawa da gaske cikin idan blocks.
# D2: aiki yana ganin duniyarta kawai (global + na kanta) — lexical scoping.
# Kowane layi "PASS" ... "FAIL" idan hakan ya lalace.
# (Every line should print PASS. FAIL would mean the old bugs are back.)

fara

    # D1 — katse a cikin idan: duk bayan katse ba za a aiwatar da su ba
    rubuta "D1 katse a cikin idan:"
    var i = 0
    maimaita (i < 5) {
        idan i == 2 {
            katse
            rubuta "FAIL — katse bai tsaya ba"
        }
        i = i + 1
    }
    idan i == 2 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D1 — ci_gaba a cikin idan: yana hawa zuwa maimaita na gaba
    rubuta "D1 ci_gaba a cikin idan:"
    var bai4 = gaskiya
    ga n cikin [1, 2, 3, 4] {
        idan n == 3 {
            ci_gaba
            rubuta "FAIL — ci_gaba bai tsaya ba"
        }
        idan n == 3 {
            rubuta "FAIL — 3 ya wuce"
        }
    }
    rubuta "PASS"

    # D1 — mayar a cikin idan a cikin maimaita yana fita duka
    rubuta "D1 mayar a cikin idan:"
    aiki nema(jeri, abu) {
        ga x cikin jeri {
            idan x == abu {
                mayar "an_sami"
            }
        }
        mayar "babu"
    }
    idan nema([10, 20, 30], 20) == "an_sami" {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D1 — katse cikin maimaita na ciki baya kawo bayan ga na waje
    rubuta "D1 katse baya tsallaka iyaka:"
    var kira_waje = 0
    ga a cikin [1, 2] {
        var j = 0
        maimaita (j < 10) {
            j = j + 1
            idan j == 3 {
                katse
            }
        }
        kira_waje = kira_waje + 1
    }
    idan kira_waje == 2 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D2 — aiki ba ta ganin ma'abotan mai kiranta (lexical scoping)
    rubuta "D2 lexical scoping:"
    aiki shiru() {
        var nawa = 42
        mayar nawa
    }
    idan shiru() == 42 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

    # D2 — shadowing: na ciki yana amfani da nasa, ba na waje ba
    rubuta "D2 shadowing:"
    var x = 1
    aiki m() {
        var x = 100
        mayar x
    }
    idan m() == 100 da x == 1 {
        rubuta "PASS"
    } amma {
        rubuta "FAIL"
    }

ƙare
