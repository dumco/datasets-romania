## Alegerile parlamentare din 2020
Descarcă setul de date original în format CSV: [link](https://github.com/dumco/datasets-romania/releases/download/alegeri-parlamentare-2020/parlamentare-2020-original.zip).

## Descriere
Setul de date conține prezența la vot și rezultatele alegerilor Parlamentare
din 6 decembrie 2020. Datele originale au fost publicate de AEP pe platforma [prezenta.roaep.ro](https://prezenta.roaep.ro/parlamentare06122020/).
Din păcate descărcarea tuturor fișierelor CSV de la AEP este dificilă, așa că
le-am încărcat în acest repository ca o singură arhivă `.zip`.

### Structura arhivei cu datele originale
- directorul `prezenta/` conține date despre prezența în secțiile de votare din România și din străinătate, pe ore;
- directorul `rezultate/` conține rezultatele provizorii, parțiale și finale ale alegerilor. Exemple:
    - rezultatele **provizorii** pentru **Camera Deputaților** în județul **Prahova** sunt în fișierul `prov/pv_prov_cnty_cd_ph.csv`
    - rezultatele **finale** pentru **Senat** în județul **Iași** sunt în fișierul `final/pv_final_cnty_s_is.csv`
    - rezultatele **finale** pentru **Senat** în **străinătate** sunt în fișierul `final/pv_final_cnty_s_sr.csv`
    - rezultatele **finale** pentru **Senat** în **străinătate**, dar **prin corespondență** sunt în fișierul `final/pv_final_cnty_sc_sr.csv`

