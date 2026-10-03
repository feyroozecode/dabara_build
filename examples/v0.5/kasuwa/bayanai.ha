# bayanai.ha — karanta farashi daga rubutu zuwa jerin ƙamus

# "shinkafa,450" → ƙamus { "kaya": "shinkafa", "farashi": 450 }
# Layin da bai dace ba yana jefa kuskure (jefa) — mai kira ne zai kama shi.
fitar aiki fassara_layi(layi) {
    naɗa sassa = tsaga(datse(layi), ",")
    idan tsawo(sassa) != 2 {
        jefa "layi bai dace ba: " + layi
    }
    naɗa kudi = lamba(sassa[1])
    mayar ƙamus { "kaya": sassa[0], "farashi": kudi }
}

# Yana mayar da ƙamus: { "lafiya": jeri, "kurakurai": jeri }
fitar aiki karanta_farashi(hanya) {
    naɗa lafiya = []
    naɗa kurakurai = []
    ga layi cikin tsaga(karanta_fayil(hanya), "\n") {
        idan datse(layi) != "" {
            gwada {
                lafiya = lafiya.ƙara(fassara_layi(layi))
            } kama (k) {
                idan nau'i(k) == "ƙamus" {
                    kurakurai = kurakurai.ƙara(k["saƙo"])
                } amma {
                    kurakurai = kurakurai.ƙara(k)
                }
            }
        }
    }
    mayar ƙamus { "lafiya": lafiya, "kurakurai": kurakurai }
}
