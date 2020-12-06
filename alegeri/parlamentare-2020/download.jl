include("common.jl")

using CSV
using DataFrames


ORIGINAL_URL = "https://github.com/dumco/datasets-romania/releases/download/alegeri-parlamentare-2020/parlamentare-2020-original.zip"
SIRUTA_URL = "https://github.com/dumco/datasets-romania/releases/download/siruta-2020-06/siruta-2020-06-csv.zip"

function download_upstream()
    @info "creating original directory $ORIGINAL_DIR/..."
    mkpath(ORIGINAL_DIR)

    @info "downloading hourly presence..."
    for hour = 7:21
        file = "presence_2020-12-06_" * lpad(hour, 2, "0") * "-00.csv"
        url = "https://prezenta.roaep.ro/parlamentare06122020/data/csv/simpv/$file"
        out = "$ORIGINAL_DIR/presence/$file"
        @debug "downloading $url..."
        `curl -s --compressed --create-dirs -o $out $url` |> run
    end

    @info "downloading domestic results..."
    for_each_type_chamber_county() do type, chamber, county
        file = "pv_$(type)_cnty_$(chamber)_$(county).csv"
        url = "https://prezenta.roaep.ro/parlamentare06122020/data/csv/sicpv/$file"
        out = "$ORIGINAL_DIR/results/$type/$file"
        @debug "downloading $url..."
        `curl -s --compressed --create-dirs -o $out $url` |> run
    end

    @info "downloading results abroad..."
    for_each_type_chamber() do type, chamber
        for voting_method = ["", "c"]
            file = "pv_$(type)_cnty_$(chamber)$(voting_method)_sr.csv"
            url = "https://prezenta.roaep.ro/parlamentare06122020/data/csv/sicpv/$file"
            out = "$ORIGINAL_DIR/results/$type/$file"
            @debug "downloading $url..."
            `curl -s --compressed --create-dirs -o $out $url` |> run
        end
    end

    @info "done."
end

function download_original()
    @info "downloading original dataset..."
    zipped = download(ORIGINAL_URL)

    @info "unzipping..."
    `unzip $zipped` |> run
    rm(zipped)

    @info "done."
end

function download_siruta()
    @info "downloading SIRUTA dataset..."
    zipped = download(SIRUTA_URL)

    @info "unzipping..."
    `unzip $zipped -d siruta/` |> run
    rm(zipped)

    @info "done."
end


download_upstream()
# download_original()
download_siruta()

