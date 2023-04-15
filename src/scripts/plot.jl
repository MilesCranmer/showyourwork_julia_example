using Plots
using CSV
using DataFrames

input_fname = ARGS[1]
output_fname = ARGS[2]

data = open(input_fname, "r") do io
    CSV.read(io, DataFrame)
end

# Plot x vs y:
plot(data.x, data.y, label="sin(x)")
savefig(output_fname)
