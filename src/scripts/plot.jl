using Plots
using CSV
using DataFrames

input_fname = snakemake.input["data"]
output_fname = snakemake.output[1]

data = open(input_fname, "r") do io
    CSV.read(io, DataFrame)
end

# Plot x vs y:
plot(data.x, data.y, label="sin(x)")
savefig(output_fname)
