ORIGINAL = "https://github.com/dumco/datasets-romania/releases/download/siruta-2020-06/siruta-2020-06-original.zip"
DIACRITICS = "https://github.com/dumco/datasets-romania/releases/download/siruta-2020-06/diacritice.csv"

@info "downloading original dataset..."
zipped = download(ORIGINAL)
diacritics = download(DIACRITICS)

@info "unzipping to original/"
`unzip $(zipped) -d original/` |> run
rm(zipped)

@info "copying diacritics file..."
mv(diacritics, "$(mkpath("util"))/diacritice.csv")

@info "done."
