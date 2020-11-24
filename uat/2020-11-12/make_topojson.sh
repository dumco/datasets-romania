#!/bin/bash

mapshaper \
    -verbose \
    -i combine-files geojson/unitate_administrativa_tara.geojson \
                     geojson/unitate_administrativa_judet.geojson \
                     geojson/unitate_administrativa_uat.geojson \
    -rename-layers country=unitate_administrativa_tara \
    -rename-layers county=unitate_administrativa_judet \
    -rename-layers local=unitate_administrativa_uat \
    -each 'name=Name.toUpperCase()' \
    -rename-fields siruta=natCode,sirutaPath=localId \
    -filter-fields siruta,sirutaPath,name \
    -clean target=* \
    -o topojson/romania.topojson target=* id-field=siruta bbox \
    -o topojson/romania.pretty.topojson target=* id-field=siruta bbox prettify \
    -simplify 25% stats \
    -o topojson/romania.simplified-4x.topojson target=* id-field=siruta bbox \
    -simplify 5% stats \
    -o topojson/romania.simplified-20x.topojson target=* id-field=siruta bbox
