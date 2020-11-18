## SIRUTA/2020-06
Descarcă setul de date procesat în format CSV: [link](https://github.com/dumco/datasets-romania/releases/download/siruta-2020-06/siruta-2020-06-csv.zip).

## Descriere
[SIRUTA](https://ro.wikipedia.org/wiki/SIRUTA) (Sistemul Informatic al
Registrului Unităților Teritorial - Administrative) reprezintă o clasificare
utilizată de Institutul Național de Statistică (INS) pentru a înregistra Unitățile
administrativ - teritoriale (UAT). Fiecare UAT este identificată unic printr-un
cod numeric – SIRUTA.

Registrul Unităților Teritorial - Administrative este structurat pe trei niveluri
coresponzătoare următoarelor tipuri de unități teritorial - administrative:
- județe (prefecturi), municipiul București;
- municipii, orașe, comune (primării);
- localități componente, sate, sectoare din București.

Registrul este utilizat în probleme de statistică, fiind corelat cu codificarea NUTS
(Nomenclatorul Unităților Teritoriale Statistice), utilizată în Uniunea Europeană.

Setul de date SIRUTA este oferit de [INS](http://colectaredate.insse.ro/senin/classifications.htm?selectedClassification=SIRUTA_S1_2020&action=download)
în fiecare semestru. Ediția de față a fost publicată în iulie 2020.

## Generarea datelor în format CSV
Pentru a genera datele în format CSV sunt necesare două comenzi:
```
$ julia download.jl
$ julia make_csv.jl
```

Scriptul `download.jl`:
- descarcă setul de date [original](https://github.com/dumco/datasets-romania/releases/download/siruta-2020-06/siruta-2020-06-original.zip)
  în directorul `original/`
- descarcă fișierul `util/diacritice.csv`:
    - acest [fișier](https://github.com/dumco/datasets-romania/releases/download/siruta-2020-06/diacritice.csv)
      este obținut manual din `original/sir_diacritic.rtf`, care este aproape
      în format TSV (coloanele sunt separate prin `\t`-uri)
    - este necesar pentru includerea diacriticelor în fișierele CSV procesate

Scriptul `make_csv.jl` generează datasetul în format CSV în directorul `csv/`:

Următoarele secțiuni descriu fișierele CSV rezultate și coloanele acestora.

### `csv/1-zone.csv`
Coloane:
- `ZONA`: număr zonă (folosit în coloanele `ZONA` din `judete.csv` și `REGIUNE` din `siruta.csv`)
- `SIRUTA`: cod de identificare SIRUTA
- `DENZONA`: denumire zonă

Zonele sunt echivalentul nivelului european [NUTS 2](https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Romania).

### `csv/2-judete.csv`
Coloane:
- `JUD`: număr județ (folosit în coloana `JUD` din `siruta.csv`)
- `DENJ`: denumire județ
- `FSJ`: factor de sortare pe județe (folosit în coloana `FSJ` din `siruta.csv`)
- `MNEMONIC`: abreviere județ (corespunde [ISO 3166-2:RO](https://en.wikipedia.org/wiki/ISO_3166-2:RO))
- `ZONA`: codul zonei din care face parte județul (coloana `ZONA` din `zone.csv`)

Județele sunt echivalentul nivelului european [NUTS 3](https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Romania).

### `csv/3-uat.csv`
Coloane:
- `SIRUTA`: cod de identificare SIRUTA
- `NIV`: nivel SIRUTA
    - 1 - judeţ
    - 2 - unităţi administrativ-teritoriale (municipiu, oraş, comună)
    - 3 - localităţi componente şi sate
- `SIRSUP`: cod de identificare pentru unitatea
administrativă ierarhic superioară
- `TIP`: tip de localitate
    - 40: județ / municipiul București
    -  1: municipiu reședință de județ, municipiul București
    -  2: oraș ce aparține de județ, altele decât reședință de județ
    -  3: comună
    -  4: municipiu, altele decât reședință de județ
    -  5: oraș reședință de județ
    -  6: sectoarele municipiului București
    -  9: localitate componentă, reședință de minicipiu
    - 10: alte localități ale municipiului
    - 11: sat ce aparține de municipiu
    - 17: localitate componentă, reședința de oraș
    - 18: localități componente ale orașului, altele decât reședința de oraș
    - 19: sate subordonate unui oraș
    - 22: sat reședință de comună
    - 23: sate ce aparțin de comună, altele decât reședința de comună
- `DENLOC`: denumire unitate administrativ teritorială / localitate
- `ULT`: ?
- `MED`: cod mediu
    - 0 - județe
    - 1 - urban
    - 3 - rural
- `JUD`: cod de județ
- `PREFIX`: ?
- `REGIUNE`: codul zonei din care face parte intrarea (coloana `ZONA` din `zone.csv`)
- `CODP`: cod poștal
- `FSJ`: factor de sortare pe județe
- `FS2`: ?
- `FS3`: ?
- `FSL`: factor de sortare în ordinea alfabetică a localităților
- `FICTIV`: ?

## Informații utile
- standardul NUTS:
    - https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Romania
    - https://ec.europa.eu/eurostat/en/web/nuts/national-structures
- alte standarde pentru structuri administrative:
    - https://en.wikipedia.org/wiki/ISO_3166-2:RO
    - https://en.wikipedia.org/wiki/List_of_FIPS_region_codes_(P–R)#RO:_Romania
- Julia:
    - https://dataframes.juliadata.org/stable
    - https://github.com/JuliaData/DBFTables.jl
    - https://csv.juliadata.org
