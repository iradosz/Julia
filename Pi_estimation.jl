# zdefiniuj funkcję π

function π(liczba_symulacji)
    n = 0  # licznik trafień w okrąg
    for i in 1:liczba_symulacji
        x, y = rand(), rand()
        if x^2 + y^2 <= 1.0
            n += 1
        end
    end
    return 4n/liczba_symulacji
end

# uruchom dla 10^k

for k in 1:6
    local liczby_symulacji = 10^k
    przyblizenie = π(liczby_symulacji)
    println("Dla liczby symulacji $liczby_symulacji przybliżenie liczby π wynosi $przyblizenie")
end

# narysuj wykres oszacowania

using Plots

symulacje = [10^k for k in 1:6]
estymacje_π = [π(n) for n in symulacje]

plot1 = plot(symulacje, estymacje_π, xaxis=:log10, label="", xlabel="Liczba symulacji", ylabel="Przybliżenie liczby π", ylim=(2, 4), xticks=10 .^ (1:6), titlefontsize=9)
title!("Estymacje liczby π w zależności od liczby symulacji")

# wykonaj po 1000 symulacji i wylicz statystyki

using Statistics

liczby_symulacji = 10 .^(1:5)
wyniki = []

for k in 1:5
    przyblizenia_pi = [π(liczby_symulacji[k]) for i in 1:1000]
    local percentyl_5 = quantile(przyblizenia_pi, 0.05)
    local percentyl_95 = quantile(przyblizenia_pi, 0.95)
    srednia = mean(przyblizenia_pi)
    push!(wyniki, (k=k, liczby_symulacji=liczby_symulacji[k], percentyl_5=percentyl_5, percentyl_95=percentyl_95, srednia=srednia))
end

using DataFrames

df_wyniki = DataFrame(wyniki)

# narysuj wykres jak zmieniają się te statystyki od liczby symulacji

percentyl_5 = [w.percentyl_5 for w in wyniki]
percentyl_95 = [w.percentyl_95 for w in wyniki]
srednie = [w.srednia for w in wyniki]

plot2 = plot(liczby_symulacji, percentyl_5, fillrange=percentyl_95, label="5 oraz 95 percentyl", alpha=0.3, titlefontsize=9, ylim=(2, 4))
plot!(liczby_symulacji, srednie, label="Średnia", xscale=:log10)
xlabel!("Liczba symulacji")
ylabel!("Przybliżenie liczby π")
title!("Percentyle i średnia w zależności od liczby symulacji")
xticks!(10 .^(1:5))

# prezentacja powstałych wykresów oraz tabeli statystycznej

plot3 = plot(plot1, plot2, layout=(1,2), size=(800, 600))
display(df_wyniki)
display(plot3)