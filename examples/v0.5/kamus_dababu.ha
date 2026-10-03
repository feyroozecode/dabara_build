# v0.5 Sprint 1 — "Ƙamus da babu"
# Rajistan kaya na ainihi: ƙamus (dictionaries), babu (nil), maɓallai,
# darajoji, share, ƙunshi akan ƙamus. Duk suna buguwa PASS/FAIL kansu.

fara

    # Rajistan kasuwa: farashin kayayyaki a ƙamus
    naɗa kasuwa = ƙamus {
        "shinkafa": 1200,
        "gishiri": 400,
        "nama": 2500,
        "doya": 950
    }

    rubuta "Farashin kasuwa:"
    ga kaya cikin kasuwa {
        rubuta "  " + kaya + ": ₦" + kasuwa[kaya]
    }

    # Sabunta farashi, ƙara sabon kaya
    kasuwa["shinkafa"] = 1350
    kasuwa["mai"] = 1800
    idan kasuwa["shinkafa"] == 1350 da ƙunshi(kasuwa, "mai") {
        rubuta "PASS — sabuntawa da ƙarawa"
    } amma {
        rubuta "FAIL — sabuntawa da ƙarawa"
    }

    # maɓallai, darajoji, share, tsawo
    rubuta "Maɓallai: " + maɓallai(kasuwa)
    rubuta "Tsawo: " + tsawo(kasuwa)
    naɗa kasa = share(kasuwa, "gishiri")
    idan tsawo(kasa) == tsawo(kasuwa) - 1 da ba ƙunshi(kasa, "gishiri") {
        rubuta "PASS — share"
    } amma {
        rubuta "FAIL — share"
    }

    # Tara farashin duka (tara + darajoji)
    naɗa duka = tara(darajoji(kasuwa))
    rubuta "Jimillar farashi: ₦" + duka

    # babu: aiki ba tare da mayar ba, kuma babu ba 0 ba
    aiki nemi(kasuwa, kaya) {
        idan ƙunshi(kasuwa, kaya) {
            mayar kasuwa[kaya]
        }
    }
    idan nemi(kasuwa, "nama") == 2500 {
        rubuta "PASS — nemi"
    } amma {
        rubuta "FAIL — nemi"
    }
    idan nemi(kasuwa, "wake") == babu {
        rubuta "PASS — babu ba 0 ba"
    } amma {
        rubuta "FAIL — babu ba 0 ba"
    }
    idan babu == babu da babu == 0 == karya {
        rubuta "PASS — babu bambancinsa da sifili"
    } amma {
        rubuta "FAIL — babu bambancinsa da sifili"
    }

    # ƙamus da aka saka (nested): rajistar dalibai
    naɗa dalibai = ƙamus {
        "Musa": ƙamus { "lissafi": 85, "turanci": 72 },
        "Aisha": ƙamus { "lissafi": 91, "turanci": 88 }
    }
    dalibai["Musa"]["lissafi"] = 90
    idan dalibai["Musa"]["lissafi"] == 90 da dalibai["Aisha"]["turanci"] == 88 {
        rubuta "PASS — ƙamus da aka saka"
    } amma {
        rubuta "FAIL — ƙamus da aka saka"
    }

ƙare
