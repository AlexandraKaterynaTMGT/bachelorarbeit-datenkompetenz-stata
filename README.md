# Bachelorarbeit: Wahrgenommene datenbezogene digitale Kompetenz

**Welche Rolle spielen dabei Alter und Geschlecht?**
Bachelorarbeit im Fach Soziologie, Universität Hamburg (2026), Note 1,3

## Fragestellung
Untersucht wird, ob Geschlecht, Alter und Bildung damit zusammenhängen, wie Menschen ihre eigene datenbezogene digitale Kompetenz einschätzen.

## Daten
GESIS-Datensatz ZA7693, Version 1.0.0 (N = 1.505, Deutschland 2021)

Der Datensatz ist nicht enthalten und kann über GESIS bezogen werden.
Link: https://doi.org/10.4232/1.13778

## Vorgehen in Stata
- Prüfung fehlender Werte (Chi²-Tests) und listenweiser Ausschluss
- Bildung eines additiven Mittelwertindex zur wahrgenommenen Datenkompetenz (Cronbachs α = 0,78)
- Dummy-Kodierung der unabhängigen Variablen (Geschlecht, Alter, Bildung)
- Gewichtete lineare Regressionen (Modelle M1–M4) und Modellvergleich
- Regressionsdiagnostik, u. a. Prüfung auf Multikollinearität (VIF)

## Dateien
- `BA_wddK_Kateryna Bohatyrova_.do`: vollständiger Stata-Code der Analyse
