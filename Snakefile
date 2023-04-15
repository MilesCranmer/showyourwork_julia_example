import os

os.environ["JULIA_PROJECT"] = "."
os.environ["JULIA_NUM_THREADS"] = "auto"

envvars:
    "JULIA_PROJECT",
    "JULIA_NUM_THREADS",

rule julia_manifest:
    input: "Project.toml"
    output: "Manifest.toml"
    shell: "julia -e 'using Pkg; Pkg.instantiate()'"

rule data:
    input: "Manifest.toml"
    output: "src/data/mydata.csv"
    script: "src/scripts/data.jl"

rule plot:
    input:
        "Manifest.toml",
        data="src/data/mydata.csv",
        # ^ Can name these for easier reference in the script.
        # https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#julia
    output: "src/tex/figures/myplot.png"
    script: "src/scripts/plot.jl"
