# rahoto.ha — gina rahoto daga jerin ƙamus

fitar aiki layin_rahoto(abu) {
    mayar abu["kaya"] + ": " + rubutu(abu["farashi"]) + " CFA"
}

fitar aiki gina_rahoto(abubuwa, kurakurai) {
    naɗa layuka = canza(abubuwa, layin_rahoto)
    naɗa jimla = tara(canza(abubuwa, aiki(a) { mayar a["farashi"] }))
    naɗa layuka_duka = layuka.ƙara("Jimla: " + rubutu(jimla) + " CFA")
    idan tsawo(kurakurai) > 0 {
        layuka_duka = layuka_duka.ƙara("An tsallake layuka " + rubutu(tsawo(kurakurai)))
    }
    mayar layuka_duka.haɗa("\n")
}
