ORIGINAL_DIR = "original"
SIRUTA_DIR = "siruta"

function normalize(s::String)
	chars = Dict('Ã' => 'Ă', 'ã' => 'ă',
				 'Ǎ' => 'Ă', 'ǎ' => 'ă',
				 'Ş' => 'Ș', 'ş' => 'ș',
				 'Ţ' => 'Ț', 'ţ' => 'ț')
	replace(s, ['Ã', 'ã', 'Ǎ', 'ǎ', 'Ş', 'ş', 'Ţ', 'ţ'] => c -> chars[c])
end

function for_each_type_chamber_county(fn)
    RESULT_TYPES = ["prov", "part", "final"]
    PARLIAMENT_CHAMBERS = ["cd", "s"]
    COUNTIES_AND_SECTORS = ["ab", "ar", "ag", "bc", "bh", "bn", "bt", "bv", "br", "bz",
                            "cs", "cl", "cj", "ct", "cv", "db", "dj", "gl", "gr", "gj",
                            "hr", "hd", "il", "is", "if", "mm", "mh", "ms", "nt", "ot",
                            "ph", "sm", "sj", "sb", "sv", "tr", "tm", "tl", "vs", "vl", "vn",
                            "s1", "s2", "s3", "s4", "s5", "s6"]
    for type = RESULT_TYPES
        for chamber = PARLIAMENT_CHAMBERS
            for county = COUNTIES_AND_SECTORS
                fn(type, chamber, county)
            end
        end
    end
end

# only used once to generate hardcoded county/sectors list
function generate_counties_and_sectors()
    @info "reading counties from the SIRUTA dataset..."
    siruta_counties = CSV.File("siruta/2-judete.csv") |> DataFrame
    sort!(siruta_counties, :FSJ)
    county_codes = [
                    # counties
                    filter(≠("B"), siruta_counties.MNEMONIC)
                    # Bucharest sectors
                    ["S$(i)" for i = 1:6]
                   ] .|> lowercase
    county_codes
end

