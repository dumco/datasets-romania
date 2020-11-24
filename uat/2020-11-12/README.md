## Unități administrativ teritoriale + limite / 2020-11-12
Descarcă setul de date procesat în format GeoJSON sau TopoJSON: [link](https://github.com/dumco/datasets-romania/releases/tag/uat-2020-11-12).

Coordonatele sunt în sistemul geodetic [WGS84](https://en.wikipedia.org/wiki/World_Geodetic_System#A_new_World_Geodetic_System:_WGS_84).

## Descriere
Preluată din [nomenclatorul gestionarilor de date spațiale](http://geoportal.gov.ro/Geocatalog/OrganizationThemeSets/MetadataDetails?themeDataSetId=2c47c2d3-9d65-4989-b005-c9b4b72c80b6):
> Set de date care conține limitele Unităților Administrativ Teritoriale (UAT),
> rezultate în urma derulării proiectului RELUAT (Registrul Electronic al Unităților
> Administrativ Teritoriale).
> [...]
> Limitele au fost stabilite prin implicarea următorilor factori: prefecturi, primării
> și OCPI. În cazul în care nu au fost agreate limitele UAT aflate în vecinătate,
> acestea sunt marcate ca fiind contestate. Culegerea informațiilor cartografice de tip
> vector din aceasta clasă de obiecte, inclusiv atributele aferente, s-a realizat în
> perioada 2005-2006, utilizând ca sursă planurile la scară 1:5000 și 1:10000 elaborate
> și editate la IGFCOT în perioada 1970-1985. În perioada 2010-2012 limitele UAT au fost
> modificate ca urmare a derulării proiectului RELUAT. Având în vedere contestațiile
> existente, datele vector din aceasta clasă de obiecte sunt în curs de actualizare.
> [...]
> Formatul seturilor de date încărcate pe acest site este KMZ, forma compresată a
> formatului KML, ce stochează datele în sistemul WGS84. Transformarea datelor in KMZ
> a fost făcută folosind aplicația ShapeKMLTransdatRO versiunea 1.02.

Nota editorului: deși fișierele originale au extensia `.kmz`, sunt de fapt KML-uri
necomprimate.

## Transformarea datelor în format GeoJSON
Pentru a transforma datele în format [GeoJSON](https://tools.ietf.org/html/rfc7946):
```
$ make geojson
```
Este nevoie ca `julia` să fie instalat și în PATH. Codul este testat cu Julia 1.5.3.

Scriptul `download.jl` descarcă setul de date [original](https://github.com/dumco/datasets-romania/releases/download/uat-2020-11-12/uat-2020-11-12-original.zip)
în directorul `original/`. Scriptul `make_geojson.jl` generează datasetul în format
GeoJSON în directorul `geojson/`.

## Transformarea datelor în format TopoJSON
Pentru a transforma datele în format [TopoJSON](https://github.com/topojson/topojson):
```
$ make topojson
```
Pasul acesta are nevoie de utilitarul [Mapshaper](https://github.com/mbloch/mapshaper).
Codul este testat cu Mapshaper 0.5.24.

Fișierele TopoJSON nu conțin toate câmpurile din setul de date original, ci doar
ce am considerat eu că este cu adevărat important, anume denumiri și coduri SIRUTA.

## Fișiere GeoJSON
- `limita_administrativa_tara.geojson`: frontiera țării
- `limita_administrativa_judet.geojson`: limite de județ
- `limita_administrativa_uat.geojson`: limite de demarcație între unități
  administrative vecine. Au fost stabilite prin implicarea următorilor factori:
  prefecturi, primării, OCPI-uri, ANCPI, instituții publice. Limitele unităților
  administrative vecine care nu au fost agreate de către unul din factorii
  implicați au fost marcate ca fiind neagreate (`"LegalStatus": "nonAgreed"`)
- `unitate_administrativa_tara.geojson`: frontiera țării
- `unitate_administrativa_judet.geojson`: perimetrele județelor
- `unitate_administrativa_uat.geojson`: perimetrele unităților administrative
  la nivel local

Câteva proprietăți interesante ale unităților sunt:
- `localID` (ex. `1.387.169681`): identificator local, atribuit de furnizorul
  de date. Nu există niciun alt obiect spațial care să aibă același identificator.
- `natLevel`: nivelul la care se situează unitatea administrativă în ierarhia
  administrativă națională:
    - `1stOrder`: țară
    - `2ndOrder`: județ și municipiul București
    - `3rdOrder`: unitățile administrativ teritoriale (municipii, oraș, comună,
        sectoarele municipiului București)
- `natLevName`: numele nivelului la care se situează unitatea administrativă în
  ierarhia administrativă națională. Ex: `tara`, `judet`, `municipiu`, `oras`,
  `comuna`, `sector`
- `natCode` (ex. `169681`): codul SIRUTA al unității administrative. Vezi
  [setul de date SIRUTA](https://github.com/dumco/datasets-romania/tree/main/siruta/2020-06).

Fișierele sunt minificate și sunt greu de citit cu ochiul liber. Puteți folosi
utilitarul `jq` pentru pretty-printing:
```
$ jq . limita_administrativa_tara.geojson | less
```

Mai multe detalii despre fișiere și semnificația proprietăților obiectelor
conținute se găsesc în fișierul `descriereclaseobiectecampurikmz.xls` din setul
de date original.

## Fișiere TopoJSON
- `romania.topojson` conține toată topologia, în 3 layere:
  - `country`: frontiera țării
  - `counties`: formele județelor
  - `local`: UAT-urile la nivel local: municipii, orașe, comune
- `romania.pretty.topojson`: același conținut, dar lizibil
- `romania.simplified-4x.topojson`: același conținut, dar păstrând numai 25% din detalii
- `romania.simplified-20x.topojson`: același conținut, dar păstrând numai 5% din detalii

## Informații utile
- https://mapshaper.org
  - https://github.com/mbloch/mapshaper/wiki/Command-Reference
- https://tools.ietf.org/html/rfc7946
  - https://macwright.com/2015/03/23/geojson-second-bite
- https://github.com/topojson/topojson
- https://nextjournal.com/sdanisch/cartographic-visualization
- https://spatialreference.org
