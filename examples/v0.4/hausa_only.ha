# v0.4 — "Dabara ta zama Hausa"
# Shirin Hausa mai tsabta: ba da turanci ɗaya ba a cikin lambar.
# (A pure-Hausa program: not one English word in the code itself.
#  Every check prints PASS. FAIL would mean an identity regression.
#  Sunaye daga docs/KEYWORDS.md — provisoire, jiran Kwamitin Harshe.)

naɗa suna = "Musa"

aiki gaisuwa(suna, lokaci) {
    idan lokaci < 12 {
        mayar "Ina kwana, " + suna
    } ammaidan lokaci < 18 {
        mayar "Ina wuni, " + suna
    } amma {
        mayar "Ina yamma, " + suna
    }
}

rubuta gaisuwa(suna, 9)
rubuta gaisuwa("Aisha", 20)

# Jeri, tsawo, jera, juya, tara — duka sunayen Hausa
naɗa farashi = [1200, 800, 2500, 950]
rubuta "Tsawon jeri: " + tsawo(farashi)
rubuta "Jimar duka: " + tara(farashi)
# Mafi girma: jeri na ƙarshe bayan jera
naɗa a_je = jera(farashi)
rubuta "Mafi girma: " + a_je[tsawo(a_je) - 1]
ga f cikin jera(farashi) {
    rubuta "₦" + f
}

# ƙamus-type aiki na ƙidaya: lambobi masu maimaita da ba a maimaita ba
naɗa maita = 0
naɗa ba_maita = 0
ga n cikin [1, 2, 3, 4, 5, 6] {
    idan n % 2 == 0 {
        maita = maita + 1
    } amma {
        ba_maita = ba_maita + 1
    }
}
idan maita == 3 da ba_maita == 3 {
    rubuta "PASS — rarrabuwar lambobi"
} amma {
    rubuta "FAIL — rarrabuwar lambobi"
}

# Kwatance da jerin jimloli (D7) da nau'i (S2)
idan "a" < "b" da 1 == 1.0 da nau'i(suna) == "jimla" {
    rubuta "PASS — kima da nau'i"
} amma {
    rubuta "FAIL — kima da nau'i"
}

# Ci gaba a maimaita (S1: ci gaba a cikin idan)
naɗa ba_uku = 0
ga n cikin [1, 2, 3, 4] {
    idan n == 3 {
        ci gaba
    }
    ba_uku = ba_uku + 1
}
idan ba_uku == 3 {
    rubuta "PASS — ci gaba"
} amma {
    rubuta "FAIL — ci gaba"
}
