# YodaFiles
Creating a package to interface the YODA format for Histograms into Julia. This format is predominantly used in high-energy particle physics such as for the MC validation tool RIVET. 
For more information on the YODA file format visit the YODA homepage https://yoda.hepforge.org/ or the GitLab at
https://gitlab.com/hepcedar/yoda

[![Build Status](https://github.com/salvolc/Yoda.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/salvolc/Yoda.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/salvolc/Yoda.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/salvolc/Yoda.jl)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)

## Example of Histo1D objects

```julia
using YodaFiles
using Plots

myhist = get_all_histograms("myfile.yoda") # Returns a 2D array with names and histograms
plot(myhist[1,2])

histerrs = get_all_errs("myfile.yoda") # Returns the uncertainties of the histograms as an array
```
