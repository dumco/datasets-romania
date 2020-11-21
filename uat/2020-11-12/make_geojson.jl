import EzXML, GeoJSON, GeoInterface
using ProgressMeter

function normalize(s::String)
    chars = Dict(
        'Ã' => 'Ă',
        'ã' => 'ă',
        'Ǎ' => 'Ă',
        'ǎ' => 'ă',
        'Ş' => 'Ș',
        'ş' => 'ș',
        'Ţ' => 'Ț',
        'ţ' => 'ț',
    )
    replace(s, ['Ã', 'ã', 'Ǎ', 'ǎ', 'Ş', 'ş', 'Ţ', 'ţ'] => c -> chars[c])
end

function coordinates2vec(coordinates::EzXML.Node)::Vector{Vector{Float64}}
    [parse.(Float64, split(coords, ',')) for coords = split(coordinates.content)]
end

function placemark2feature(placemark::EzXML.Node, ns)::GeoInterface.Feature
    # extract attributes
    sds = findall("kml:ExtendedData/kml:SchemaData/kml:SimpleData", placemark, ns)
    props = Dict(normalize(sd["name"]) => normalize(sd.content) for sd = sds)

    # extract coords
    polygons = [[coordinates2vec(coords) for coords = findall(".//kml:coordinates", polygon, ns)]
                for polygon = findall(".//kml:Polygon", placemark, ns)]
    linestrings = [coordinates2vec(coords)
                   for coords = findall(".//kml:LineString/kml:coordinates", placemark, ns)]
    # exactly one should be empty
    @assert isempty(polygons) ⊻ isempty(linestrings)

    geom = if !isempty(polygons)
        length(polygons) > 1 ?
            GeoInterface.MultiPolygon(polygons) :
            GeoInterface.Polygon(polygons |> first)
    else
        # there should be exactly one `<LineString>/<coordinates>` in a Placemark
        @assert length(linestrings) == 1
        GeoInterface.LineString(linestrings |> first)
    end
    GeoInterface.Feature(geom, props)
end

function kml2geojson(inout::Pair{String, String})
    in, out = inout
    @info "converting $(in) to $(out)..."
    @info "reading KML from $(in)..."
    doc = EzXML.readxml(in)
    ns = ["kml" => EzXML.namespace(doc.root)]

    @info "extracting attributes and coordinates..."
    features = GeoInterface.Feature[]
    @showprogress 1 "extracting..." for placemark = EzXML.findall("//kml:Placemark", doc.root, ns)
        push!(features, placemark2feature(placemark, ns))
    end

    @info "generating GeoJSON..."
    json = GeoInterface.FeatureCollection(features) |> GeoJSON.write

    @info "writing GeoJSON to $(out)..."
    open(out, "w") do io
        write(io, json)
    end
    @info "done."
end

OUTPUT_DIR = "geojson"
@info "creating output directory $(OUTPUT_DIR)/..."
mkpath(OUTPUT_DIR)

kml2geojson.([
    "original/unitate_administrativa_tara.kmz" => "$(OUTPUT_DIR)/unitate_administrativa_tara.geojson",
    "original/unitate_administrativa_judet.kmz" => "$(OUTPUT_DIR)/unitate_administrativa_judet.geojson",
    "original/unitate_administrativa_uat.kmz" => "$(OUTPUT_DIR)/unitate_administrativa_uat.geojson",
    "original/limita_administrativa_tara.kmz" => "$(OUTPUT_DIR)/limita_administrativa_tara.geojson",
    "original/limita_administrativa_judet.kmz" => "$(OUTPUT_DIR)/limita_administrativa_judet.geojson",
    "original/limita_administrativa_uat.kmz" => "$(OUTPUT_DIR)/limita_administrativa_uat.geojson",
])
