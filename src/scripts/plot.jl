using Gadfly
using Cairo
using CSV
using DataFrames

input_fname = snakemake.input["data"]
output_fname = snakemake.output[1]

data = open(input_fname, "r") do io
    CSV.read(io, DataFrame)
end

# Plot x vs y:
p = plot(data, x=:x, y=:y, Geom.line)

# Save:
draw(PNG(output_fname, 10cm, 7.5cm), p)
