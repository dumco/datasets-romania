ORIGINAL = "https://github.com/dumco/datasets-romania/releases/download/uat-2020-11-12/uat-2020-11-12-original.zip"

@info "downloading original dataset..."
zipped = download(ORIGINAL)

@info "unzipping to original/"
`unzip $(zipped) -d original/` |> run
rm(zipped)

@info "done."
