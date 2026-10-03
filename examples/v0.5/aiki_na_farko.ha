# v0.5 Sprint 2 — "Aiki na Farko" (first-class functions & closures)
# Aiki yanzu ƙima ce: naɗa f = gaisuwa, canza(jeri, aiki(x){...}), kuma
# fermetures suna riƙe yanayi (compteur). Duk suna buguwa PASS/FAIL kansu.

fara

    # Aiki a matsayin ƙima: naɗa f = sunan_aiki
    aiki ninka_biya(n) { mayar n * 5 }
    naɗa biya = ninka_biya
    idan biya(6) == 30 {
        rubuta "PASS — naɗa f = aiki"
    } amma {
        rubuta "FAIL — naɗa f = sunan_aiki"
    }

    # Aiki mara suna (anonymous) a matsayin sakaiko
    naɗa farashi = [1200, 800, 2500, 950]
    naɗa sababbi = canza(farashi, aiki(f) { mayar f + 100 })
    idan sababbi[0] == 1300 da sababbi[1] == 900 {
        rubuta "PASS — canza da aiki mara suna"
    } amma {
        rubuta "FAIL — canza da aiki mara suna"
    }

    # Zaɓa: kayan da suka fi 1000
    naɗa tsada = zaɓa(farashi, aiki(f) { mayar f > 1000 })
    idan tsawo(tsada) == 2 da tsada[0] == 1200 {
        rubuta "PASS — zaɓa da aiki mara suna"
    } amma {
        rubuta "FAIL — zaɓa da aiki mara suna"
    }

    # Fermeture: mai ƙidaya — yanayin yana ci gaba da tsayawa
    aiki mai_ƙidaya() {
        naɗa ƙidaya = 0
        mayar aiki() {
            ƙidaya = ƙidaya + 1
            mayar ƙidaya
        }
    }
    naɗa muna_ƙidaya = mai_ƙidaya()
    muna_ƙidaya()
    muna_ƙidaya()
    idan muna_ƙidaya() == 3 {
        rubuta "PASS — fermeture na riƙe yanayi"
    } amma {
        rubuta "FAIL — fermeture na riƙe yanayi"
    }

    # Fermeture tana karanta muhallinta
    aiki mai_karatu(ƙasa, wuri) {
        mayar aiki(suna) { mayar ƙasa + " — " + wuri }
    }
    naɗa niger = mai_karatu("Niger", "Niamey")
    idan niger("A") == "Niger — Niamey" {
        rubuta "PASS — fermeture na karanta muhalli"
    } amma {
        rubuta "FAIL — fermeture na karanta muhalli"
    }

    # Aiki a matsayin sakaiko a cikin sakaiko (two-deep)
    aiki yi_amfani(k, x) { mayar k(x) }
    idan yi_amfani(aiki(x) { mayar x * x }, 7) == 49 {
        rubuta "PASS — aiki a cikin aiki"
    } amma {
        rubuta "FAIL — aiki a cikin aiki"
    }

    # Sunayen jimla suna aiki har yanzu (dacewa)
    aiki ninka_biyu(n) { mayar n * 2 }
    naɗa hanyar_tsohuwa = canza([1, 2], "ninka_biyu")
    idan hanyar_tsohuwa[0] == 2 da hanyar_tsohuwa[1] == 4 {
        rubuta "PASS — sakaiko da suna"
    } amma {
        rubuta "FAIL — sakaiko da suna"
    }

ƙare