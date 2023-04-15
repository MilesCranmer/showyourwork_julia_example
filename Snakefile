rule julia_manifest:
    input: "Project.toml"
    output: "Manifest.toml"
    shell: "julia --project=. -e 'using Pkg; Pkg.instantiate()'"
    # Note this will use the system Julia, not the one in the conda environment.

rule data:
    input: "src/scripts/data.jl", "Manifest.toml"
    output: "src/data/mydata.csv"
    shell: "julia --project=. {input[0]} {output}"

rule plot:
    input: "src/scripts/plot.jl", "src/data/mydata.csv", "Manifest.toml"
    output: "src/tex/figures/myplot.png"
    shell: "julia --project=. {input[0]} {input[1]} {output}"
