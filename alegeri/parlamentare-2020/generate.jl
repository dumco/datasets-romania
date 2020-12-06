include("common.jl")

using CSV
using DataFrames


OUTPUT_DIR = "generated"

function create_output_dir()
    @info "creating output directory $OUTPUT_DIR/..."
    mkpath(OUTPUT_DIR)
end

function make_presence_by_lau()
    @info "reading original presence dataset..."
    presence = CSV.File("$ORIGINAL_DIR/presence/presence_2020-12-06_21-00.csv") |> DataFrame
    transform!(presence, :Localitate => ByRow(normalize) => :Localitate)

    @info "reading SIRUTA dataset..."
    siruta_uat = CSV.File("$SIRUTA_DIR/3-uat.csv") |> DataFrame

    @info "fixing Bucharest sectors SIRUTA codes..."
    with_lau_siruta = leftjoin(
        presence, siruta_uat[!, [:SIRUTA, :SIRSUP, :DENLOC]],
        on=[:Localitate => :DENLOC,
            :Siruta => :SIRSUP])
    presence.Siruta .= ifelse.(presence.Judet .== "B", with_lau_siruta.SIRUTA, presence.Siruta)

    @info "summing presence counts by SIRUTA code..."
    aggregated_cols = names(presence, 8:230)
    by_siruta = groupby(presence, :Siruta)
    uat = combine(by_siruta, :Judet, [col => sum => col for col = aggregated_cols])

    @info "adding correct names by joining with SIRUTA..."
    uat = innerjoin(uat, siruta_uat[!, [:SIRUTA, :DENLOC]], on=(:Siruta => :SIRUTA))
    select!(uat, :Judet => :JUDET, :Siruta => :SIRUTA, :DENLOC => :UAT, Not([:Judet, :Siruta, :DENLOC]))
    rename!(uat,
        "Votanti pe lista permanenta" => :VLP,
        "Votanti pe lista complementara" => :VLC,
       )

    @info "writing generated CSV file..."
    uat |> CSV.write("$OUTPUT_DIR/presence-by-uat.csv")

    @info "done."
end

function make_results_by_lau()
    for result_type = ["prov"]
        for chamber = ["cd", "s"]
            results = DataFrame()

            @info "reading `$result_type` results, chamber `$chamber`..."
            for county = county_codes
                file = "$ORIGINAL_DIR/$result_type/pv_$result_type_cnty_$(chamber)_$(county).csv"
                df = CSV.File(file) |> DataFrame
                rename!(normalize, df)
                for col = [:precinct_county_name, :precinct_name, :uat_name]
                    transform!(df, col => ByRow(normalize) => col)
                end
                append!(results, df, cols=:union)
            end
            results = coalesce.(results, 0)

            @info "fixing Bucharest sectors SIRUTA codes..."
            with_lau_siruta = leftjoin(results, siruta_uat[!, [:SIRUTA, :SIRSUP, :DENLOC]],
                                       on=[:uat_name => :DENLOC,
                                           :uat_siruta => :SIRSUP])
            results.uat_siruta .= ifelse.(results.uat_siruta .== 179132, with_lau_siruta.SIRUTA, results.uat_siruta)

            @info "summing results by SIRUTA code..."
            aggregated_cols = names(results)[13:end]
            by_uat = groupby(results, :uat_siruta)
            results_by_uat = combine(by_uat, :precinct_county_name, [col => sum => col for col = aggregated_cols])

            @info "adding correct names by joining with SIRUTA..."
            results_by_uat = innerjoin(results_by_uat, siruta_uat[!, [:SIRUTA, :DENLOC]], on=(:uat_siruta => :SIRUTA))
            select!(results_by_uat, :precinct_county_name => :JUDET, :DENLOC => :UAT, :uat_siruta => :SIRUTA, Not([:precinct_county_name, :uat_siruta, :DENLOC]))
            # rename!(results_by_uat,
            #     "Votanti pe lista permanenta" => :VLP,
            #     "Votanti pe lista complementara" => :VLC,
            # )

            # TODO
        end
    end
end


create_output_dir()
make_presence_by_lau()
# make_results_by_lau()

