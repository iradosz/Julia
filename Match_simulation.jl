using Plots
using Statistics

# Zapisz funkcję symulującą mecz do 10 punktów

function symuluj_mecz()
    wynik1 = 0
    wynik2 = 0

    while wynik1 < 10 && wynik2 < 10
        if rand() < 0.5
            wynik1 += 1
        else
            wynik2 += 1
        end
    end

    if wynik1 == 10
        return "Gracz 1 wygrał mecz!"
    else
        return "Gracz 2 wygrał mecz!"
    end
end

# Wybierz statystykę testową - w tym przypadku różnica bramek pomiędzy graczami
# Napisz funkcję wyliczającą statystykę testową dla pojedynczego meczu

function oblicz_statystyke(punkty_do_wygranej)
    wynik1 = 0
    wynik2 = 0

    while wynik1 < punkty_do_wygranej && wynik2 < punkty_do_wygranej
        if rand() < 0.5
            wynik1 += 1
        else
            wynik2 += 1
        end
    end

    if wynik1 > wynik2
        return wynik1 - wynik2
    else
        return wynik2 - wynik1
    end
end

# Wysymuluj 10000 meczy i wylicz statystyke testową

wyniki = []
for i in 1:10000
    wynik = oblicz_statystyke(10)
    push!(wyniki, wynik)
end

# Narysuj histogram wyliczonych statystyk testowych

plot1 = histogram(wyniki, xlabel="Różnica bramek", ylabel="Liczba wystąpień", label="")

# Wylicz 95 percentyl wysymulowanych statystyk

percentyl_95 = quantile(wyniki, 0.95)

# Narysuj wykres zależności wartości krytycznej od goli potrzebnych do wygranej

wyniki2 = []
punkty_do_wygranej = 5*(1:20)
for k in 1:20
    wynik = [oblicz_statystyke(punkty_do_wygranej[k]) for i in 1:1000]
    percentyle_95 = quantile(wynik, 0.95)
    push!(wyniki2, (k=k, punkty_do_wygranej=punkty_do_wygranej[k], percentyle_95=percentyle_95))
end

p95 = [w.percentyle_95 for w in wyniki2]

plot2 = plot(punkty_do_wygranej, p95, xlabel="Punkty do wygranej", ylabel="Percentyl 95", label="")

# Prezentacja powstałych wykresów

plot3 = plot(plot1, plot2, layout=(1,2))
display(plot3)