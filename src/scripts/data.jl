using CSV

x = 0.0:0.01:10π
y = sin.(x)

output_fname = ARGS[1]

open(output_fname, "w") do io
    CSV.write(io, (x=x, y=y))
end
