# PolyhedralOmega.jl benchmarks

This repository contains scripts and data for testing and benchmarking the [PolyhedralOmega.jl](https://github.com/alcyon-lab/PolyhedralOmega.jl) library.


## Running PolyhedralOmega on a single json
```sh
$ julia --project="." run_example.jl benchmark_data/basic/3.json
```

## Usage of converters

```jl
include("converters.jl")

latte_file = open("magic_4x4.latte", "r")
out_json_file = open("magic_4x4.json", "w")
latte_to_json(latte_file,out_json_file)
close(latte_file)
close(out_json_file)

json_file = open("magic_4x4.json", "r")
out_latte_file = open("magic_4x4.latte", "w")
json_to_latte(json_file,out_latte_file)
close(json_file)
close(out_latte_file)
```
