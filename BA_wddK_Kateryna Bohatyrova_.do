/********************************************************************************
*******************************************************************************

Bachelorarbeit: "Wahrgenommene datenbezogene digitale Kompetenz: 
                 Welche Rolle spielen dabei Alter und Geschlecht?"       
Zweck:           Sekundäranalyse
Datenquelle:     GESIS-Datensatz (N = 1.505); Link: https://doi.org/10.4232/1.13778
Autorin:         Kateryna Bohatyrova
Universität:     Universität Hamburg
Datum:           8.09.2026

********************************************************************************/
********************************************************************************
********************************************************************************


*===============================================================================
*OPERATIONALISIERUNG:
*===============================================================================


/*In diesem Abschnitt werden die relevanten Variablen bereinigt und für die Analyse vorbereitet.*/
 
 
********************************************************************************
******************************************************************************** 

*I. Abhängige Variable (INDEX): Wahrgenommene datenbezogene digitale Kompetenz (wddK)

********************************************************************************
********************************************************************************


*-------------------------------------------------------------------------------
* TEIL 1: Prüfung der Items
*-------------------------------------------------------------------------------


*Überblick über die Struktur der Items (vgl. BA, Übers. I)
*Kontrolle, ob Variablennamen und Labels korrekt vorliegen, bevor mit den Werten weitergearbeitet wird
describe dig3_1 dig3_2 dig3_3 dig3_4 dig3_5


*Prüfen: Arithmetisches Mittel, Standardabweichung, Min/Max 
summarize dig3_1 dig3_2 dig3_3 dig3_4 dig3_5

/*Ergebnis: 
1. Obs. durchgängig 1.505, 
2. Wertebereich einheitlich 1-6 
3. Means (2,43-3,51) liegen nicht an den Rändern
4. SDs (0,87-1,05) zeigen echte Streuung
=> Werte sind plausibel*/


/*Kopien der Originalvariablen anlegen: 
alle weiteren Schritte laufen auf den "_clean"-Variablen*/
clonevar dig3_1_clean = dig3_1
clonevar dig3_2_clean = dig3_2
clonevar dig3_3_clean = dig3_3
clonevar dig3_4_clean = dig3_4
clonevar dig3_5_clean = dig3_5


*Labels für die Kopien vergeben
label var dig3_1_clean "Frage3: Datensicherheit im Home-Office"
label var dig3_2_clean "Frage3: Phishing-Mails erkennen"
label var dig3_3_clean "Frage3: Datenverwendung durch soziale Medien"
label var dig3_4_clean "Frage3: Datenverwendung durch Gesundheits-/Fitness-Apps"
label var dig3_5_clean "Frage3: Datenverwendung durch Parkplatzsuche-Apps"


*Value Labels der Items anzeigen
label list LABA

/*Ergebnis: 
1. Werte 1-4 bilden die inhaltliche Kompetenz-Skala von "sehr gut" bis "weiß gar nichts darüber" 
(Wert 4 benennt das Fehlen von Wissen und ist damit eine Selbsteinschätzung)
2. Die Werte 5 "weiß nicht" und 6 "k.A."*/


/*Die Antwortkategorien 5-6 werden nicht als eigenständige Kompetenzausprägungen berücksichtigt
=> als fehlende Werte definieren:*/
mvdecode dig3_1_clean dig3_2_clean dig3_3_clean dig3_4_clean dig3_5_clean, mv(5 6)


*Anzahl der Fälle mit vollständigen gültigen Angaben in allen fünf Items
count if !missing(dig3_1_clean, dig3_2_clean, dig3_3_clean, dig3_4_clean, dig3_5_clean)

/*Ergebnis:
Zwischenstand der Datenbasis: N = 1.448*/


*Kontrolle nach dem Definieren der fehlenden Werte:
summarize dig3_1_clean dig3_2_clean dig3_3_clean dig3_4_clean dig3_5_clean

/*Ergebnis: 
1. Obs variieren je nach Item zwischen 1.474 und 1.488 
2. Wertebereich einheitlich 1-4 bei allen Items
=> Werte 5 "weiß nicht" und 6 "k.A." wurden erfolgreich als Missing kodiert*/



/*Cronbachs Alpha auf den bereinigten Items berechnen: 
Prüfen, ob die 5 Items dasselbe Konstrukt (wddK) messen*/
alpha dig3_1_clean dig3_2_clean dig3_3_clean dig3_4_clean dig3_5_clean

/*Ergebnis: 
1. Average interitem covariance: 0,37 => Items kovariieren positiv
2. Scale reliability coefficient: 0.7814 (>= 0,70) => Index kann gebaut werden*/


/*Detaillierte Itemanalyse: 
Prüfen, ob einzelne Items die Skala schwächen und ob der Ausschluss eines Items die Reliabilität relevant verbessern würde*/
alpha dig3_1_clean dig3_2_clean dig3_3_clean dig3_4_clean dig3_5_clean, item detail

/*Ergebnis:
1. Alle Items zeigen eine gute Trennschärfe (Item-rest corr. > 0.30).
2. Der Ausschluss von dig3_5_clean würde das Alpha nur marginal von 0.7814 auf 0.7826 erhöhen 
=> kein Ausschluss nötig; Alle 5 Items verbleiben in der Skala. Der Index wird daraus gebildet.*/



*-------------------------------------------------------------------------------
* TEIL 2: Umpolung
*-------------------------------------------------------------------------------


/*Skalenrichtung prüfen: 
Welche Ausprägung der Skala für hohe bzw. niedrige Kompetenz steht*/
codebook dig3_1_clean

/*Ergebnis: 
Wert 1 ("sehr gut") steht für die höchste Kompetenz, Wert 4 ("weiß gar nichts darüber") für die niedrigste 
=> die Skala ist invers kodiert und muss vor der Indexbildung umgepolt werden*/


*Items umpolen, sodass höhere Werte eine höhere Kompetenz hindeuten
/*Originalcodierung: 1 = "sehr gut" bis 4 = "weiß gar nichts darüber" wird gespiegelt zu 
                     1 = niedrige,      4 = hohe Kompetenz*/
recode dig3_1_clean (1=4) (2=3) (3=2) (4=1), gen(dig3_1_pol)
recode dig3_2_clean (1=4) (2=3) (3=2) (4=1), gen(dig3_2_pol)
recode dig3_3_clean (1=4) (2=3) (3=2) (4=1), gen(dig3_3_pol)
recode dig3_4_clean (1=4) (2=3) (3=2) (4=1), gen(dig3_4_pol)
recode dig3_5_clean (1=4) (2=3) (3=2) (4=1), gen(dig3_5_pol)



*KONTROLLE nach der Umpolung:

/*a) 
1. Anzahl gültiger Werte je umgepoltem Item muss der Anzahl gültiger Werte im 
jeweiligen Ursprungsitem entsprechen
2. Mittelwerte sollten im Vergleich zu den ursprünglichen Werten gespiegelt sein*/
summarize dig3_1_pol dig3_2_pol dig3_3_pol dig3_4_pol dig3_5_pol

*Zum direkten Vergleich:
summarize dig3_1_clean dig3_2_clean dig3_3_clean dig3_4_clean dig3_5_clean

/*Ergebnis: 
1. Anzahl gültiger Fälle durchgehend ungeändert
2. Die neuen Mittelwerte entsprechen genau den umgekehrten ursprünglichen Mittelwerten
(z.B. dig3_1: 2,69 -> 2,31; dig3_5: 3,47 -> 1,53), 
3. Wertebereich weiterhin 1-4 bei allen Items 
=> Umpolung verlief ohne Verzerrung*/


/*b) 
Cronbachs Alpha berechnen, um zu prüfen, 
ob sich die interne Konsistenz durch die Umpolung verändert hat*/
alpha dig3_1_pol dig3_2_pol dig3_3_pol dig3_4_pol dig3_5_pol

*Zum direkten Vergleich:
alpha dig3_1_clean dig3_2_clean dig3_3_clean dig3_4_clean dig3_5_clean

/*Ergebnis: 
Cronbachs Alpha = 0,7814, identisch zum Wert vor der Umpolung*/


*Labels für die umgepolten Variablen vergeben:
label var dig3_1_pol "Datensicherheit im Home-Office"
label var dig3_2_pol "Phishing-Mails erkennen"
label var dig3_3_pol "Soziale Medien: Datenverwendung"
label var dig3_4_pol "Gesundheits-/Fitnessapps: Datenverwendung"
label var dig3_5_pol "Parkplatzsuche-Apps: Datenverwendung"



*Value Labels an die umgepolte Skalenrichtung anpassen
label define LABA_pol 1 "weiß gar nichts darüber" 2 "weniger gut" 3 "gut" 4 "sehr gut"

label values dig3_1_pol LABA_pol
label values dig3_2_pol LABA_pol
label values dig3_3_pol LABA_pol
label values dig3_4_pol LABA_pol
label values dig3_5_pol LABA_pol


*-------------------------------------------------------------------------------
*TEIL 3: Indexbildung (wddK): Vergleich tolerant (A) vs. strict (B)
*-------------------------------------------------------------------------------


/*Prüfen, ob die strengere (strict) Variante zu nennenswert anderen Ergebnissen führt als die tolerantere Variante*/


*Version A (tolerant): Index bilden, wenn mindestens ein gültiges Item vorliegt
egen index_tolerant = rowmean(dig3_1_pol dig3_2_pol dig3_3_pol dig3_4_pol dig3_5_pol)

*Diagnostik: Für wie viele der fünf Items liegt pro Person eine gültige Antwort vor?
egen n_valid_dig = rownonmiss(dig3_1_pol dig3_2_pol dig3_3_pol dig3_4_pol dig3_5_pol)
tab n_valid_dig

/*Ergebnis: 
1. 11 fehlende Werte generiert => 11 Befragte hatten bei allen fünf Items keinen gültigen Wert
2. 1 Person mit 2 gültigen Antworten, 14 mit 3, 31 mit 4, 
3. 1.448 Personen (96,21%) mit allen 5 gültigen Items 
=> überwiegender Teil der Stichprobe hat vollständige Angaben*/


*Kontrolle der Eigenschaften des toleranten Index (mindestens 1 gültige Antwort vorhanden)
summarize index_tolerant

*Ergebnis: N = 1.494



*Version B (strict): Index nur bei vollständigen Angaben in allen fünf Items
egen index_strict = rowmean(dig3_1_pol dig3_2_pol dig3_3_pol dig3_4_pol dig3_5_pol)

*Ergebnis: 11 Befragte hatten bei allen fünf Items gar keinen gültigen Wert


*Bereinigung, damit nur vollständige Fälle bleiben
replace index_strict = . if missing(dig3_1_pol, dig3_2_pol, dig3_3_pol, dig3_4_pol, dig3_5_pol)

*Ergebnis: 46 weitere Befragten hatten unvollständige Angaben und wurden als fehlend gesetzt


*Kontrolle: Eigenschaften des strikten Index (nur vollständige Angaben)
summarize index_strict

*Ergebnis: N = 1.448



*Vergleich: Unterscheiden sich tolerante und strikte Indexbildung nennenswert von einander?
summarize index_tolerant index_strict

/*Ergebnis:
nahezu identisch:
tolerant: M = 2,19; SD = 0,69 (gerundet) vs. strict: M = 2,19; SD = 0,69 (gerundet)
=> Da sich die Verteilung des Index zwischen der toleranten und der strikten Variante kaum unterscheidet, 
verwende ich den strikten Index, der nur auf vollständigen Angaben beruht.*/



*Version A (tolerant) ist nicht mehr benötigt:
drop index_tolerant


*Version B (strict): Der finale, für die Analyse verwendete Index umbenennen
rename index_strict index_kompetenz


/*Hilfsvariable löschen: "n_valid_dig"-Variable diente nur der vorangegangenen Diagnostik 
und wird für die weitere Analyse nicht mehr gebraucht*/
drop n_valid_dig


*Finale Kontrolle der Eigenschaften vom wddK-Index
summarize index_kompetenz

/*Ergebnis: 
1. N = 1448; 
2. M = 2.19; 
3. SD = 0.69; 
4. Wertebereich = 1 bis 4*/
/*Die Fallzahl entspricht exakt der bereits in TEIL 1 ermittelten Anzahl (N = 1448) bei vollständigen 
Angaben in allen fünf Items, was zusätzlich bestätigt, dass Umpolung und Indexbildung nichts verzerrt hat*/

*Labeln der Variable "index_kompetenz"
label var index_kompetenz "wahrgenommene datenbezogene digitale Kompetenz"



********************************************************************************
********************************************************************************


*II. Unabhängige Variablen (UV): Geschlecht, Alter, Bildung (Kontrollvariable)


********************************************************************************
********************************************************************************


*Geschlecht (UV)


*-------------------------------------------------------------------------------
*TEIL 1: Prüfung der Variable
*-------------------------------------------------------------------------------


*Variable prüfen: Kodierung, Wertebereich und fehlende Werte kontrollieren
codebook s2

/*Ergebnis:
1. Kodierung: 1 = Männer, 2 = Frauen
2. Keine fehlenden Werte
3. N = 1.505*/


*Häufigkeitsverteilung der beiden Kategorien:
tab s2

/*Ergebnis: 
814 Männer (54 %)
691 Frauen (46 %)*/


*Arbeitskopie der Originalvariable erstellen
gen geschlecht = s2


*Label und Value-Label vergeben
label variable geschlecht "Geschlecht (Ref.: Männlich)"
label values geschlecht S2


*-------------------------------------------------------------------------------
*TEIL 2: Vorbereitung der Variable (Dummy-Kodierung)
*-------------------------------------------------------------------------------


*Dummy-Variable erstellen: Frauen = 1, Männer = 0 ("männlich" als Referenzkategorie)


generate weiblich = (geschlecht == 2)


*Label vergeben
label var weiblich "Geschlecht"


*Value Labels definieren und zuweisen
label define weiblich_lab 0 "männlich" 1 "weiblich"
label values weiblich weiblich_lab

*Kontrolle: Stimmt die Dummy-Kodierung mit der Ursprungsvariable überein?
tab geschlecht weiblich, missing

/*Ergebnis: 
1) Alle 814 Männer erhalten den Wert 0, alle 691 Frauen den Wert 1
2) keine fehlenden Werte 
=> Dummy korrekt kodiert*/


********************************************************************************
********************************************************************************


*Alter (UV)


*-------------------------------------------------------------------------------
*TEIL 1: Prüfung der Variable
*-------------------------------------------------------------------------------


*Variable prüfen: Kodierung, Wertebereich und fehlende Werte kontrollieren
codebook s3

/*Ergebnis:
1. Kodierung: 1 = 14-29 Jahre
              2 = 30-44 Jahre
			  3 = 45-59 Jahre
			  4 = 60+ J.
			  5 = Rest (7 Fälle)
2. Keine fehlenden Werte
3. N = 1.505*/


*Häufigkeitsverteilung der Kategorien ausgeben
tab s3

/*Ergebnis:
14-29 Jahre: 162 (10,8%)
30-44 Jahre: 245 (16,3%)
45-59 Jahre: 438 (29,1%)
60+ Jahre:   653 (43,4%)
Rest:        7   (0,5%)
=> Kategorie "Rest" (Wert 5) enthält keine Altersangabe und wird als fehlend definiert*/


*Arbeitskopie der Originalvariable erstellen
gen alter = s3


*Label und Value-Label vergeben
label variable alter "Alter (Ref.: 14-29 Jahre)"
label values alter S3


*Kategorie "Rest" (5) als fehlend definieren
replace alter = . if alter == 5

/*Ergebnis: 7 Fälle auf fehlend gesetzt*/


*Verteilung inkl. fehlender Werte prüfen
tab alter, missing

/*Ergebnis: Die 7 Rest-Fälle erscheinen nun als fehlend (.), 
die vier inhaltlichen Kategorien bleiben unverändert*/


*Verteilung ohne fehlende Werte prüfen
tab alter

/*Ergebnis: 
1) N = 1.498 gültige Fälle in vier Alterskategorien
2) 14-29 Jahre: 162 (10,8%)
   30-44 Jahre: 245 (16,4%)
   45-59 Jahre: 438 (29,2%)
   60+ Jahre:   653 (43,6%)*/


*-------------------------------------------------------------------------------
*TEIL 2: Vorbereitung der Variable (Dummy-Kodierung)
*-------------------------------------------------------------------------------


*Jüngste Gruppe (14-29) dient als Referenz und wird gegen die drei älteren Gruppen verglichen
gen alter_30_44 = (alter == 2) if !missing(alter)
gen alter_45_59 = (alter == 3) if !missing(alter)
gen alter_60plus = (alter == 4) if !missing(alter)

/*Ergebnis: 
Die 7 Rest-Fälle gehen nicht in die Analyse ein*/


*Dummies beschriften
label var alter_30_44 "Altersgruppe 30-44"
label var alter_45_59 "Altersgruppe 45-59"
label var alter_60plus "Altersgruppe über 60"

*Value Labels definieren und zuweisen
label define ja_nein 0 "nein" 1 "ja"
label values alter_30_44 alter_45_59 alter_60plus ja_nein


*Kontrolle: Stimmen die Dummy-Kodierungen mit der Ursprungsvariable überein?
tab alter alter_30_44, missing
tab alter alter_45_59, missing
tab alter alter_60plus, missing

/*Ergebnis: 
1. Jeder Dummy weist genau den Fällen seiner Altersgruppe den Wert 1 zu, alle übrigen erhalten 0 
2. die 7 Rest-Fälle erscheinen als fehlend 
=> Dummies korrekt kodiert*/

********************************************************************************
********************************************************************************


*Bildung (UV; Kontrollvariable in Regressionanalyse)


*-------------------------------------------------------------------------------
*TEIL 1
*-------------------------------------------------------------------------------


*Variable prüfen: Kodierung, Wertebereich und fehlende Werte kontrollieren
codebook s5

/*Ergebnis:
1. Kodierung: 1 = Hauptschule; 2 = mittlerer Abschluss; 3 = Hochschule/Abitur; 4 = Rest (48 Fälle)
2. Keine fehlenden Werte (0/1.505)
3. N = 1.505*/


*Häufigkeitsverteilung der Kategorien:
tab s5

/*Ergebnis:
1. Hauptschule:         178 (11,8%)
2. mittlerer Abschluss: 412 (27,4%)
3. Hochschule/Abitur:   867 (57,6%)
4. Rest:                48  (3,2%)
=> Kategorie "Rest" (4) enthält keinen inhaltlichen Abschluss und wird im nächsten Schritt als fehlend definiert*/


*Arbeitsvariable aus der Originalvariable erstellen
gen bildung = s5


*Kategorie "Rest" (4) als fehlend definieren
replace bildung = . if bildung == 4

/*Ergebnis: 
48 Fälle auf fehlend gesetzt*/


*Label und Value-Label vergeben
label variable bildung "Bildung (Ref.: Hauptschule)"
label values bildung S5


*Verteilung inkl. fehlender Werte prüfen
tab bildung, missing

/*Ergebnis: 
Die 48 Rest-Fälle erscheinen nun als fehlend (.), die drei inhaltlichen Kategorien bleiben unverändert*/


*Verteilung ohne fehlende Werte
tab bildung

/*Ergebnis: 
1) N = 1.457 gültige Fälle in drei Bildungskategorien
2) Hauptschule:         178 (12,2%)
   mittlerer Abschluss: 412 (28,3%)
   Hochschule/Abitur:   867 (59,5%)*/


*-------------------------------------------------------------------------------
*TEIL 2: Vorbereitung der Variable (Dummy-Kodierung)
*-------------------------------------------------------------------------------


*Dummies bauen:
*Niedrigste Gruppe (Hauptschule) dient als Referenz, gegen die die beiden höheren Abschlüsse verglichen werden
gen bildung_mittel = (bildung == 2) if !missing(bildung)
gen bildung_hoch = (bildung == 3) if !missing(bildung)

/*Ergebnis: 
Die 48 Rest-Fälle bleiben in beiden Dummies leer und zählen nicht zur Referenzgruppe*/


*Dummies beschriften
label variable bildung_mittel "Mittlerer Abschluss"
label variable bildung_hoch "Hochschulreife/Abitur"

*Value Labels zuweisen:
label values bildung_mittel bildung_hoch ja_nein


*Kontrolle: Stimmen die Dummy-Kodierungen mit der Ursprungsvariable überein?
tab bildung bildung_mittel, missing
tab bildung bildung_hoch, missing

/*Ergebnis: 
1. Jeder Dummy weist den Fällen seiner Bildungskategorie den Wert 1 zu, alle übrigen erhalten 0 
2. die 48 Rest-Fälle erscheinen als fehlend 
=> Dummies korrekt kodiert*/



********************************************************************************
********************************************************************************


*III. Ausfallanalyse der für den wddK-Index relevanten Items
 
 
********************************************************************************
********************************************************************************

*Hängen fehlende Werte bei den wddK-Items mit Geschlecht, Alter oder Bildung zusammen?


*Variable erstellen: 1 = mindestens ein Item fehlt, 0 = alle fünf Items vorhanden
gen dig_missing = missing(dig3_1_pol, dig3_2_pol, dig3_3_pol, dig3_4_pol, dig3_5_pol)


*Label zuweisen
label var dig_missing "Mind. ein wddK-Item fehlt"


*Value Labels zuweisen
label values dig_missing ja_nein


tab dig_missing

/*Ergebnis: 
1. den 57 Personen (3,79%) fehlt mindestens ein Item.
2. 1.448 (96,21%) haben alle fünf Items gültig*/


*Zusammenhang mit Geschlecht prüfen
tab dig_missing geschlecht, col chi2

/*Ergebnis: 
1. Bei Frauen fehlt häufiger mindestens ein Item (4,92%) als bei Männern (2,83%)
2. Pearson chi2(1) = 4,50, p = 0,034 
=> signifikanter Zusammenhang mit dem Geschlecht*/


*Zusammenhang mit Alter prüfen
tab dig_missing alter, col chi2

/*Ergebnis: 
1. Der Ausfall steigt mit dem Alter (14-29: 0%; 30-44: 2,04%; 45-59: 3,65%; 60+: 5,51%)
2. Pearson chi2(3) = 13,72, p = 0,003 
=> signifikanter Zusammenhang mit dem Alter*/


*Zusammenhang mit Bildung prüfen
tab dig_missing bildung, col chi2

/*Ergebnis: 
1. Der Ausfall sinkt mit steigender Bildung (Hauptschule: 6,74%; mittlerer Abschluss: 4,37%; Hochschule/Abitur: 2,65%)
2. Pearson chi2(2) = 7,92, p = 0,019 
=> signifikanter Zusammenhang mit der Bildung*/


/*Gesamtbefund: 
Der Item-Ausfall hängt signifikant mit allen drei Modellvariablen zusammen (alle p < 0,05).
=> Der Ausfall ist von beobachteten Variablen abhängig (vgl. BA, Kap. 7.2)*/


********************************************************************************
********************************************************************************


*===============================================================================
*STATISTISCHES VORGEHEN
*===============================================================================

/*Gewichtungsfaktor prüfen, Analysestichprobe über listwise deletion festlegen und 
ungewichtete gegen gewichtete Verteilungen vergleichen*/


*-------------------------------------------------------------------------------
* TEIL 1: Diagnostik des Gewichtungsfaktors
*-------------------------------------------------------------------------------


*Überblick über alle Variablen im Datensatz, um den Gewichtungsfaktor zu identifizieren
describe

/*Ergebnis: 
Der Gewichtungsfaktor trägt den Variablennamen "weight" (Label: "Gewicht")*/


*Inhalte der Variable "weight" prüfen
codebook weight

/*Ergebnis:
1. Mittelwert ≈ 1 => Gewichtungsfaktor korrekt normiert
2. Standardabweichung (SD) = 0,69 => die Gewichte streuen moderat um den Durchschnitt
3. Keine fehlenden Werte (N = 1.505)
4. Wertebereich 0,22 bis 6,97:
   - eine Person mit 0,22 zählt nur zu rund einem Fünftel einer
     Durchschnittsperson, wird also deutlich heruntergewichtet
   - eine Person mit 6,97 repräsentiert knapp sieben Durchschnittspersonen,
     wird stark hochgewichtet
5. Perzentile:
   - 10 % der Befragten haben ein Gewicht unter 0,40
   - 25 % liegen unter 0,53
   - Median bei 0,82: mindestens die Hälfte der Befragten wird in den gewichteten 
     Analysen etwas schwächer gewichtet als eine Durchschnittsperson
   - 75 % liegen unter 1,26
   - 90 % liegen unter 1,87
   => Die Verteilung ist rechtsschief: 
      mindestens die Hälfte der Gewichte liegt unterhalb des Durchschnitts von 1, 
	  während wenige stark hochgewichtete Fälle den Mittelwert nach oben ziehen*/

/*Gesamtbefund: 
Die Variable "weight" eignet sich für die Gewichtung in den weiteren Analyseverfahren*/


********************************************************************************
********************************************************************************



*-------------------------------------------------------------------------------
* TEIL 2: Analysestichprobe festlegen (listwise deletion)
*-------------------------------------------------------------------------------



/*Variable erstellen, die den gültigen Wert bei allen analyserelevanten Variablen
(AV und 3 UVs) anzeigt*/
gen analyse_n = !missing(index_kompetenz, geschlecht, alter, bildung)


*labeln der Variable, die vollständige Angaben in allen relevanten Variablen hat
label var analyse_n "Analysestichprobe"


*Label values zuweisen
label values analyse_n ja_nein
/*Ergebnis:
*ja = alle vier Variablen ("index_kompetenz", "geschlecht", "alter", "bildung") gültig; 
nein = mindestens eine fehlt*/

tab analyse_n

/*Ergebnis: 
1. 1.397 Fälle (92,82 %) mit vollständigen Werten in allen analyserelevanten Variablen, 
2. 108 Fälle   (7,18 %) ausgeschlossen.
=> Die Analysestichprobe (N = 1.397) wird für alle weiteren deskriptiven und inferenzstatistischen
Analysen herangezogen*/


********************************************************************************

*Verteilungen der finalen Analysestichprobe (N=1.397)


*Verteilung der abhängigen Variable (wddK-Index) in der Analysestichprobe
summarize index_kompetenz if analyse_n == 1

/*Ergebnis: 
M = 2,19, SD = 0,69 bei einem Wertebereich von 1 bis 4 
=> der Durchschnitt liegt leicht unter der Skalenmitte (2,5), die Befragten schätzen ihre wddK
tendenziell eher niedrig ein*/


*Geschlechterverteilung in der Analysestichprobe
tab geschlecht if analyse_n == 1

/*Ergebnis: 
762 Männer (54,6 %)
635 Frauen (45,5 %) 
=> ungewichtete Stichprobe tendiert zu männlichen Befragten*/


*Altersverteilung in der Analysestichprobe
tab alter if analyse_n == 1

/*Ergebnis: 
1. Die Altersgruppe 60+ bildet mit 600 Personen (43,0 %) die größte Gruppe, 
2. Die 14–29-Jährigen mit 160 Personen (11,5 %) die kleinste 
=> ungewichtete Stichprobe tendiert stark zu älteren Jahrgängen*/


*Bildungsverteilung in der Analysestichprobe
tab bildung if analyse_n == 1

/*Ergebnis: 
1. Hochschule/Abitur mit 840 Personen (60,1%) am stärksten vertreten
2. Hauptschule mit 164 Personen (11,7%) am schwächsten
=> ungewichtete Stichprobe tendiert stark zu höheren Abschlüssen*/



********************************************************************************
********************************************************************************



*-------------------------------------------------------------------------------
* TEIL 3: Vergleich, ungewichtete vs. gewichtete Verteilung (Analysestichprobe) 
*-------------------------------------------------------------------------------



* Index (wddK)
summarize index_kompetenz if analyse_n == 1
summarize index_kompetenz if analyse_n == 1 [aw=weight]

/*Ergebnis:
Ungewichtet: M = 2,19, SD = 0,69
Gewichtet:   M = 2,23, SD = 0,69
=> Minimale Verschiebung. Die Gewichtung verändert die abhängige Variable kaum*/


* Geschlecht
tab geschlecht if analyse_n == 1
tab geschlecht if analyse_n == 1 [aw=weight]

/*Ergebnis:
Ungewichtet: Männer 54,6 %, Frauen 45,5 %
Gewichtet:   Männer 49,8 %, Frauen 50,2 %
=> Verschiebung um 4,7 Prozentpunkte. Männer waren überrepräsentiert.
   die Gewichtung korrigiert auf ein nahezu ausgeglichenes Verhältnis.*/


* Alter
tab alter if analyse_n == 1
tab alter if analyse_n == 1 [aw=weight]

/*Ergebnis:
Ungewichtet: 14–29 J. 11,5 %; 30–44 J. 16,5 %; 45–59 J. 29,1 %; 60+ J. 43,0 %
Gewichtet:   14–29 J. 19,2 %; 30–44 J. 21,6 %; 45–59 J. 25,3 %; 60+ J. 33,9 %
=> 14–29 J. steigt um 7,8 Prozentpunkte,
   60+ J. sinkt um 9,1 Prozentpunkte. Ältere waren deutlich überrepräsentiert.*/


* Bildung
tab bildung if analyse_n == 1
tab bildung if analyse_n == 1 [aw=weight]

/*Ergebnis:
Ungewichtet: Hauptschule 11,7 %; Mittlerer Abschluss 28,1 %; Hochschule/Abitur 60,1 %
Gewichtet:   Hauptschule 10,8 %; Mittlerer Abschluss 29,5 %; Hochschule/Abitur 59,7 %
=> Kaum Verschiebung. Die Bildungsverteilung war bereits vor der
   Gewichtung nah an der Zielstruktur.*/


/*Gesamtbefund:
Es wird in weiterer Analyse die gewichtete Analysestichprobe eingesetzt*/

********************************************************************************
********************************************************************************


*===============================================================================
* I. DESKRIPTIVE STATISTIK (gewichtet)
*===============================================================================


/*Anmerkung:
- Alle Lage- und Streuungsmaße sowie prozentualen Anteile werden mit dem Gewichtungsfaktor (aweight) berechnet. 
- Die Fallzahlen (N) entsprechen der ungewichteten Anzahl tatsächlich befragter Personen.*/


*-------------------------------------------------------------------------------
* TEIL 1: AV insgesamt: Verteilungskennwerte des wddK-Index
*-------------------------------------------------------------------------------


*Zentrale Lage- und Streuungsmaße sowie Verteilungsform des Index
summarize index_kompetenz [aweight=weight] if analyse_n == 1, detail

/*Ergebnis:
1. Mittelwert: 2,23 (auf einer 4-stufigen Skala) => Der Durchschnitt liegt leicht unter der Skalenmitte (2,5)
2. Median (50%): 2,2 (nahezu identisch mit dem Mittelwert)
3. Standardabweichung: 0,69
4. Range: 1 bis 4
5. Schiefe: 0,19 (leicht rechtsschief)*/

*histogram (keine Gewichtung -> Stata nicht erlaubt)
histogram index_kompetenz if analyse_n == 1, percent title("Verteilung des wddK-Index (ungewichtet)") xtitle("wddK-Index") ytitle("Prozente") color(gs10) lcolor(black)

/*Ergebnis: 
Die Verteilung ist annähernd symmetrisch mit leichter Rechtsschiefe (Schiefe = 0,19)*/

********************************************************************************


*-------------------------------------------------------------------------------
* TEIL 2: AV nach Geschlecht
*-------------------------------------------------------------------------------


*wddK-Index nach Geschlecht (ohne Rundung)
tabstat index_kompetenz [aweight=weight] if analyse_n == 1, by(geschlecht) statistics(mean sd min max n)


*Zum Vergleich: gerundete Ausgabe (Rundung auf 2 Nachkommastellen)
tabstat index_kompetenz [aweight=weight] if analyse_n == 1, by(geschlecht) statistics(mean sd min max n) format(%9.2f)

/*Ergebnis:
 Männer: M = 2,34, SD = 0,71 (n = 762)
 Frauen: M = 2,12, SD = 0,65 (n = 635)
 Differenz: 0,22 Skalenpunkte zugunsten der Männer
 
 => deskriptiv in Richtung H1: Männer schätzen ihre wddK im Durchschnitt höher ein
    als Frauen */

*Verteilungsform des wddK-Index bei Geschlechtern veranschaulichen 
histogram index_kompetenz if analyse_n == 1, by(geschlecht, title("Verteilung des wddK-Index nach Geschlecht (ungewichtet)")) percent xtitle("wddK-Index") ytitle("Prozente") color(gs10) lcolor(black)

********************************************************************************

	
*-------------------------------------------------------------------------------
* TEIL 3: AV nach Altersgruppe
*-------------------------------------------------------------------------------


*wddK-Index nach Altersgruppe (ohne Rundung)
tabstat index_kompetenz [aweight=weight] if analyse_n == 1, by(alter) statistics(mean sd min max n)


*Zum Vergleich: gerundete Ausgabe (Rundung auf 2 Nachkommastellen)
tabstat index_kompetenz [aweight=weight] if analyse_n == 1, by(alter) statistics(mean sd min max n) format(%9.2f)

/*Ergebnis:
 14–29 Jahre: M = 2,38, SD = 0,65 (n = 160)
 30–44 Jahre: M = 2,54, SD = 0,62 (n = 230)
 45–59 Jahre: M = 2,30, SD = 0,63 (n = 407)
 60+ Jahre:   M = 1,89, SD = 0,65 (n = 600)

 => Deskriptiv teilweise in Richtung H2: die älteste Gruppe schätzt ihre wddK deutlich 
   niedriger ein als die jüngste, aber der Alterseffekt verläuft nicht linear, da die 
   30–44-Jährigen den höchsten Mittelwert aufweisen und erst ab 45–59 ein Rückgang 
   einsetzt, der bei 60+ am stärksten ausfällt*/

   
*Balkendiagramm zur Veranschaulichung des nicht-linearen Altersverlaufs
graph bar (mean) index_kompetenz [aweight=weight] if analyse_n == 1, over(alter) ytitle("Mittlerer wddK-Index") title("wddK-Index nach Altersgruppe (gewichtet)") blabel(bar,format(%9.2f))

*Verteilungsform des wddK-Index je Altersgruppe veranschaulichen 
histogram index_kompetenz if analyse_n == 1, by(alter, title("Verteilung des wddK-Index nach Altersgruppe (ungewichtet)")) percent xtitle("wddK-Index") ytitle("Prozente") color(gs10) lcolor(black)

********************************************************************************


*-------------------------------------------------------------------------------
* TEIL 4: AV nach Bildung
*-------------------------------------------------------------------------------


*wddK-Index nach Bildung (ohne Rundung)
tabstat index_kompetenz [aweight=weight] if analyse_n == 1, by(bildung) statistics(mean sd min max n)

*Zum Vergleich: gerundete Ausgabe (Rundung auf 2 Nachkommastellen)
tabstat index_kompetenz [aweight=weight] if analyse_n == 1, by(bildung) statistics(mean sd min max n) format(%9.2f)

/*Ergebnis:
 Hauptschule:       M = 1,67, SD = 0,54 (n = 164)
 Mittlerer Abschl.: M = 2,09, SD = 0,63 (n = 393)
 Hochschule/Abitur: M = 2,40, SD = 0,67 (n = 840)
 
 => je höher der Abschluss, desto höher die eingeschätzte wddK


*Gesamtbefund: Deskriptiv zeigt sich ein deutlicher Zusammenhang zwischen Bildung und wddK, 
was ihre Rolle als Kontrollvariable im Regressionsmodell stützt*/


********************************************************************************

*-------------------------------------------------------------------------------
* TEIL 5:  Kreuztabellen
*-------------------------------------------------------------------------------

/*Anmerkung
- Die folgenden Kreuztabellen zeigen die Verteilung der Prädiktoren untereinander in der Analysestichprobe. 
- Sie dienen als deskriptive Grundlage für mögliche Verflechtungen zwischen den Prädiktoren.*/


*Geschlecht x Altersgruppe (Spaltenprozente)
tab alter geschlecht [aweight=weight] if analyse_n == 1, col 

/*Ergebnis:
1. Die Altersverteilung ist zwischen Männern und Frauen weitgehend ähnlich. 
2. Unterschiede:
- Gruppe 30–44 Jahre: 
  Männer 23,99%, Frauen 19,30%. 
- Bei 60+ ist das Verhältnis umgekehrt: 
  Männer 31,78%, Frauen 35,92%*/


*Geschlecht x Bildung (Spaltenprozente)
tab bildung geschlecht [aweight=weight] if analyse_n == 1, col

/*Ergebnis:
1. Die Bildungsverteilung unterscheidet sich zwischen Männern und Frauen nur geringfügig. 
2. Unterschiede: 
- Hochschule/Abitur: zugunsten Männer
  Männer 61,78%, Frauen 57,57% 
- mittlerem Abschluss: zugunsten Frauen 
  Männer 26,88%, Frauen 32,12%
- Der Hauptschulanteil: nahezu gleich 
  Männer 11,34%, Frauen 10,31%*/


*Altersgruppe x Bildung (Spaltenprozente)
tab bildung alter [aweight=weight] if analyse_n == 1, col

/*Ergebnis:
deutlichere Unterschiede: 
1. Der Anteil mit Hochschule/Abitur sinkt von 70,28% bei den 30–44-Jährigen auf 49,85% 
2. bei 60+. Umgekehrt steigt der Hauptschulanteil von 3,46% (30–44) auf 19,03% 
3. Die jüngste Gruppe (14–29 J.) liegt mit 67,54% Hochschule/Abitur nah an den 30–44-Jährigen*/



********************************************************************************
********************************************************************************
********************************************************************************


*===============================================================================
* II. REGRESSION-MODELLE
*===============================================================================


*estout-Paket installieren; wird für die Tabellenausgabe der Regressionmodelle benötigt
ssc install estout


/*Anmerkung:
1. Alle fünf Modelle werden mit Gewichtungsfaktor berechnet ("pweight").
2. VIF-Diagnostik erfordert "aweight"*/

********************************************************************************

*TEIL 1

*-------------------------------------------------------------------------------
* M1: Geschlecht
*-------------------------------------------------------------------------------

*Bivariate Regression: Zusammenhang des Geschlechts mit der wddK (H1)
regress index_kompetenz weiblich [pweight=weight] if analyse_n == 1

/*Ergebnis:
1. Geschlechtskoeffizient: −0,22 (p < 0,001) 
=> Frauen schätzen ihre wddK signifikant niedriger ein als Männer
2. Konstante: 2,34 (Mittelwert der Ref.: Männlich)
3. R-squared = 0,024 
=> Geschlecht allein erklärt 2,4% (R-squared = 0,024) der Varianz der wddK*/

*H1 => bestätigt
 
*Modell M1 speichern
estimates store M1



*-------------------------------------------------------------------------------
* M2: Alter
*-------------------------------------------------------------------------------

*Bivariate Regression: Zusammenhang des Alters mit der wddK (H2)
regress index_kompetenz i.alter [pweight=weight] if analyse_n == 1

/*Ergebnis:
1. Koeffizienten:
30–44 Jahre:  0,16 (p = 0,031) => höhere wddK als Referenzgruppe 14–29 J.
45–59 Jahre: −0,09 (p = 0,203) => kein signifikanter Unterschied mit Referenzgruppe 14–29 J.
60+ Jahre:   −0,49 (p < 0,001) => deutlich niedrigere wddK als Referenzgruppe 14–29 J.
=> Stärkster Alterseffekt bei 60+, nicht-lineares Muster
2. Konstante: 2,38 (Mittelwert der Ref.: 14–29 Jahre)
3. R² = 0,140 
=> Alter erklärt 14,0% (R-squared = 0,140) der Varianz der wddK*/

*H2 => teilweise bestätigt

*Modell M2 speichern
estimates store M2



*-------------------------------------------------------------------------------
* M3: Geschlecht + Alter
*-------------------------------------------------------------------------------

*Multiple Regression: Geschlecht und Alter unter gegenseitiger Kontrolle
regress index_kompetenz weiblich i.alter [pweight=weight] if analyse_n == 1

/*Ergebnis:
1. Koeffizienten:
 Geschlecht:  −0,19 (p < 0,001) => bleibt signifikant unter Alterskontrolle
 30–44 Jahre:  0,15 (p = 0,048) => signifikant
 45–59 Jahre: −0,09 (p = 0,192) => nicht signifikant
 60+ Jahre:   −0,49 (p < 0,001) => signifikant
=> Beide Effekte (Geschlecht und Alter) bleiben unter gegenseitiger Kontrolle bestehen
2. Konstante:
3. R² = 0,159 (15,9 %) => Anstieg des Wertes gegenüber M1 und M2*/


*Modell M3 speichern
estimates store M3



*-------------------------------------------------------------------------------
* M4: Bildung
*-------------------------------------------------------------------------------

*Bivariate Regression: Einfluss der Bildung auf die wddK (isoliert)
regress index_kompetenz i.bildung [pweight=weight] if analyse_n == 1

/*Ergebnis:
1. Koeffizienten: 
 Mittlerer Abschluss: +0,42 (p < 0,001) => signifikant
 Hochschule/Abitur:   +0,73 (p < 0,001) => signifikant
2. Konstante: 1,67 (Mittelwert der Ref.: Hauptschule)
=> Bildung hat alleine einen signifikanten positiven Zusammenhang mit der wddK
3. R² = 0,121 => Bildung allein erklärt 12,1% der Varianz der wddK*/

 
*Modell M4 speichern
estimates store M4



*-------------------------------------------------------------------------------
* M5: Geschlecht + Alter + Bildung
*-------------------------------------------------------------------------------

*Multiple Regression: Hauptmodell mit Bildung als Kontrollvariable (H3)
regress index_kompetenz weiblich i.alter i.bildung [pweight=weight] if analyse_n == 1

/*Ergebnis:
1. Geschlecht:  −0,18 (p < 0,001) => bleibt signifikant, leichte Reduktion gegenüber M3
2. Alter: 
 30–44 Jahre:    0,13 (p = 0,070) => Signifikanz verloren unter Bildungskontrolle
 45–59 Jahre:   −0,05 (p = 0,388) => nicht signifikant
 60+ Jahre:     −0,40 (p < 0,001) => bleibt stark signifikant; Reduktion gegenüber M3 (Richtung bleibt)
=> Die Alterskoeffizienten fallen unter Bildungskontrolle geringer aus
3. Bildung:
 Mittlerer Abschluss: 0,32 (p < 0,001)
 Hochschule/Abitur:   0,58 (p < 0,001)
4. R² = 0,234 
=> der erklärte Varianzanteil steigt gegenüber M3 (Geschlecht + Alter) durch Hinzunahme der Bildung deutlich an*/

*H3 => bestätigt
 
*Modell M5 speichern
estimates store M5


********************************************************************************

*TEIL 2

*-------------------------------------------------------------------------------
* ANNAHMEN-DIAGNOSTIK: M5
*-------------------------------------------------------------------------------

* Residuen und vorhergesagte Werte berechnen
predict residuen, resid
predict fitted, xb

* 1. Normalverteilung der Residuen (QQ-Plot)
qnorm residuen, title("Q-Q-Plot") ytitle("Residuen") xtitle("Erwartete Werte bei Normalverteilung")
graph export "qqplot_residuen.png", replace

* 2. Homoskedastizität (Residual-Plot)
twoway (scatter residuen fitted), yline(0) title("Residual-Fitted-Plot") xtitle("Vorhergesagte Werte") ytitle("Residuen")

graph export "homosekd_plot.png", replace

* 3. VIF: Multikollinearität
*M5 mit aweight wiederholen, damit Variablennamen lesbar sind
regress index_kompetenz weiblich alter_30_44 alter_45_59 alter_60plus bildung_mittel bildung_hoch [aweight=weight] if analyse_n == 1


*Multikollinearität prüfen: VIF-Werte für alle Prädiktoren ausgeben
vif
 
/*=> Alle VIF-Werte liegen deutlich unter dem Schwellenwert von 4, kein Hinweis 
auf problematische Multikollinearität*/



********************************************************************************
********************************************************************************

*TEIL 3

*-------------------------------------------------------------------------------
* Übersichtstabelle (M1-M5)
*-------------------------------------------------------------------------------

*Alle Modelle in einer Tabelle darstellen (3 Kommastellen)
esttab M1 M2 M3 M4 M5, b(3) se(3) r2 ar2 label mtitles("M1" "M2" "M3" "M4" "M5") coeflabels(_cons "Konstante")

/*Ergebnis:
1. Varianz:
 R-squared-Entwicklung bei Geschlecht und Alter: 0,024 (M1) und 0,140 (M2) -> 0,159 (M3) 
 R-squared bei der Bildung:                      0,121 (M4) 
 R-squared bei allen relevanten Variablen:       0,234 (M5)
2. Koeffizientenbefunde:
 => Geschlechtseffekt bleibt über M1, M3 und M5 stabil und signifikant
 => Alterseffekt bei 60+ bleibt stark, 30–44 verliert Signifikanz in M5*/

*Alle Modelle in einer Tabelle darstellen (2 Kommastellen)
esttab M1 M2 M3 M4 M5, b(2) se(2) r2 ar2 label mtitles("M1" "M2" "M3" "M4" "M5") coeflabels(_cons "Konstante")