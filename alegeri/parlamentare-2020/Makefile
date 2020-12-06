generated: generate.jl
	julia $< && touch $@

original: download.jl
	julia $< && touch $@

.PHONY: release
release:
	mkdir $@ || touch $@
	zip -r release/parlamentare-2020-original.zip original/ -i *.csv

.PHONY: clean
clean:
	rm -rf release/ original/ siruta/ generated/

