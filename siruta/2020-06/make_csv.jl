using DataFrames, DBFTables, CSV, InvertedIndices

OUTPUT_DIR = "csv"

@info "creating output directory $(OUTPUT_DIR)/..."
mkpath(OUTPUT_DIR)

@info "loading diacritics file..."
diacritics = CSV.File("util/diacritice.csv") |> DataFrame
@info "done."

# regions
begin
    @info "loading regions data..."
    regions = DBFTables.Table("original/ZONE.DBF") |> DataFrame

    # fix typos
    @assert regions[3, :DENZONA] == "SUD  - MUNTENIA"
    regions[3, :DENZONA] = "SUD - MUNTENIA"
    @assert regions[8, :DENZONA] == "BUCURESTI - ILFOV"
    regions[8, :DENZONA] = "BUCUREȘTI - ILFOV"

    regions_csv = "$(OUTPUT_DIR)/1-zone.csv"
    @info "writing regions data to $(regions_csv)..."
    CSV.write(regions_csv, regions)
    @info "done."
end

# counties
begin
    @info "loading counties data..."
    counties_original = DBFTables.Table("original/JUD.DBF") |> DataFrame

    @info "adding diacritics to county names..."
    diacritics_counties = diacritics[diacritics.TIP .== 40, :]
    counties = innerjoin(counties_original, diacritics_counties, on=(:JUD, :JUDET))
    select!(counties, names(counties_original), :DENUMIRE_LOCALITATE => ByRow(den -> split(den, limit=2) |> last |> string) => :DENJ)

    counties_csv = "$(OUTPUT_DIR)/2-judete.csv"
    @info "writing counties data to $(counties_csv)..."
    CSV.write(counties_csv, counties)
    @info "done."
end

# LAUs
begin
    @info "loading LAU data..."
    laus_original = DBFTables.Table("original/siruta.DBF") |> DataFrame

    @info "adding diacritics to LAU names..."
    laus = innerjoin(laus_original, diacritics, on=:SIRUTA, makeunique=true, validate=(true, true))
    select!(laus, names(laus_original), :DENUMIRE_LOCALITATE => :DENLOC)

    laus_csv = "$(OUTPUT_DIR)/3-uat.csv"
    @info "writing LAU data to $(laus_csv)..."
    CSV.write(laus_csv, laus)
    @info "done."
end

@info "CSV data was written to $(OUTPUT_DIR)/."
