ORIGINAL = "https://github.com/dumco/datasets-romania/releases/download/rpl-2011/rpl-2011-original.zip"

@info "downloading original dataset..."
zipped = download(ORIGINAL)

@info "unzipping..."
`unzip $(zipped)` |> run
rm(zipped)

@info "done."
