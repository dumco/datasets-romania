topojson: make_topojson.sh geojson
	sh $< && touch $@

geojson: make_geojson.jl original
	julia $< && touch $@

original: download.jl
	julia $< && touch $@

.PHONY: clean
clean:
	rm -rf original/ geojson/ topojson/
