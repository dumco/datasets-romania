original: download.jl
	julia $< && touch $@

.PHONY: release
release:
	mkdir $@ || touch $@
	zip -r release/rpl-2011-original.zip original/ -i *.xls

.PHONY: clean
clean:
	rm -rf release/ original/
