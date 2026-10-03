# v0.5 S3a — gwada / kama / jefa (kamawa da jefa kuskure)
# Wannan misali yana duba kansa: yana buga PASS ko FAIL.

aiki raba(a, b) {
    idan b == 0 {
        jefa "ba a raba da sifili"
    }
    mayar a / b
}

aiki duba(suna, gaskiyar) {
    idan gaskiyar {
        rubuta "PASS — " + suna
    } amma {
        rubuta "FAIL — " + suna
    }
}

# 1. jefa kowace ƙima, kama ta
naɗa kama_1 = babu
gwada {
    raba(1, 0)
} kama (k) {
    kama_1 = k
}
duba("jefa jimla", kama_1 == "ba a raba da sifili")

# 2. kuskuren lokacin aiki ma ana kama shi — k ƙamus ne
naɗa kama_2 = babu
gwada {
    rubuta 5 % 0
} kama (k) {
    kama_2 = k["lamba"]
}
duba("kuskure DBR-012", kama_2 == "DBR-012")

# 3. babu kuskure: kama ba ya aiki
naɗa kama_3 = "babu"
gwada {
    raba(10, 2)
} kama (k) {
    kama_3 = "an kama"
}
duba("babu kuskure", kama_3 == "babu")

# 4. mayar a cikin gwada
aiki lafiya() {
    gwada { mayar "gwada" } kama (k) { mayar "kama" }
}
duba("mayar a cikin gwada", lafiya() == "gwada")

# 5. jefa a cikin kama (sake jefawa)
naɗa kama_5 = 0
gwada {
    gwada { jefa 7 } kama (a) { jefa a * 2 }
} kama (b) {
    kama_5 = b
}
duba("sake jefawa", kama_5 == 14)
