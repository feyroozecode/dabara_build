# main.ha — Rahoton Kasuwa (v0.5 exit demo): fayiloli uku, shigo/fitar,
# ƙamus, rufewa (closure), gwada/kama, karanta_fayil / rubuta_fayil.
# Yana duba kansa: yana buga PASS ko FAIL.

shigo karanta_farashi daga "./bayanai"
shigo gina_rahoto daga "./rahoto"

aiki duba(suna, gaskiyar) {
    idan gaskiyar {
        rubuta "PASS — " + suna
    } amma {
        rubuta "FAIL — " + suna
    }
}

naɗa sakamako = karanta_farashi("farashi.txt")
duba("layuka huɗu sun dace", tsawo(sakamako["lafiya"]) == 4)
duba("layi ɗaya mara kyau an kama", tsawo(sakamako["kurakurai"]) == 1)

naɗa rahoto = gina_rahoto(sakamako["lafiya"], sakamako["kurakurai"])
rubuta_fayil("rahoto.txt", rahoto)
duba("fayil ya wanzu", akwai_fayil("rahoto.txt"))

naɗa karanta_baya = karanta_fayil("rahoto.txt")
duba("an karanta abin da aka rubuta", karanta_baya == rahoto)
duba("jimla daidai (1550)", ƙunshi(karanta_baya, "Jimla: 1550 CFA"))
duba("an ambaci layin da aka tsallake", ƙunshi(karanta_baya, "An tsallake layuka 1"))

gwada {
    karanta_fayil("babu_wannan.txt")
    duba("fayil da babu", karya)
} kama (k) {
    duba("fayil da babu → DBR-016", k["lamba"] == "DBR-016")
}
rubuta karanta_baya
