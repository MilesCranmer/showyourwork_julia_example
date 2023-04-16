<p align="center">
<a href="https://github.com/showyourwork/showyourwork">
<img width = "450" src="https://raw.githubusercontent.com/showyourwork/.github/main/images/showyourwork.png" alt="showyourwork"/>
</a>
<br>
<br>
<a href="https://github.com/MilesCranmer/showyourwork_julia_example/actions/workflows/build.yml">
<img src="https://github.com/MilesCranmer/showyourwork_julia_example/actions/workflows/build.yml/badge.svg?branch=main" alt="Article status"/>
</a>
<a href="https://github.com/MilesCranmer/showyourwork_julia_example/raw/main-pdf/arxiv.tar.gz">
<img src="https://img.shields.io/badge/article-tarball-blue.svg?style=flat" alt="Article tarball"/>
</a>
<a href="https://github.com/MilesCranmer/showyourwork_julia_example/raw/main-pdf/ms.pdf">
<img src="https://img.shields.io/badge/article-pdf-blue.svg?style=flat" alt="Read the article"/>
</a>
</p>

An open source scientific article created using the [showyourwork](https://github.com/showyourwork/showyourwork) workflow.


# Using Julia

Fork this repo to easily use Julia in `showyourwork`. The following modifications were made to the default template
(You can also see this from the [Git diff](https://github.com/MilesCranmer/showyourwork_julia_example/compare/7dbfa577573dc8a02a9c225eb75547988684ac8c...main#files_bucket))

1. Defined `src/scripts/paths.jl`, replacing `src/scripts/paths.py` (just a convenience file which defines paths when you `include()` it).
1. Created a `Project.toml` to define Julia dependencies.
1. Created two example scripts in `src/scripts/`:
    - `data.jl`, to create a dataset and save it to `mydata.csv`, and
    - `plot.jl`, to plot the dataset and save it to `myplot.png`.
1. Created three Snakemake rules:
    - `julia_manifest` creates `Manifest.toml` from the `Project.toml`.
    - `data` calls `data.jl`, and depends on `Manifest.toml`.
    - `plot` calls `plot.jl`, and depends on `mydata.csv` and `Manifest.toml`.
1. Configured `showyourwork.yml` to map `.jl` to `julia`.
  
The `Snakefile` also defines the `JULIA_PROJECT` as `"."`.
These three Julia jobs are dependencies of the final rule, which compiles the LaTeX document using `tectonic`.
The generated PDF and arXiv tarball will contain `myplot.png`.

For example, the rule `plot`:

```yaml
rule plot:
    input:
        "Manifest.toml",
        data="src/data/mydata.csv",
    output: "src/tex/figures/myplot.png"
    script: "src/scripts/plot.jl"
```

This Julia script is then able to reference the variable `snakemake`:

```julia
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
```

In `ms.tex`, we can define the corresponding figure as:

```latex
\begin{figure}[h!]
    \centering
    \includegraphics[width=0.5\textwidth]{figures/myplot.png}
    \caption{A figure.}
    \label{fig:fig1}
    \script{../scripts/plot.jl}
\end{figure}
```

Which will add a hyperlink to the script used to generate the figure:

<img width="480" alt="Screenshot 2023-04-15 at 3 01 17 PM" src="https://user-images.githubusercontent.com/7593028/232248663-88529984-b724-4daf-81d9-5383d14ff4dd.png">

