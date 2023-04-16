using CSV

x = 0.0:0.1:10π
y = cos.(x)

open(snakemake.output[1], "w") do io
    CSV.write(io, (x=x, y=y))
end
