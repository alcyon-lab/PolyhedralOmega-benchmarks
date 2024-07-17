using PolyhedralOmega
using BenchmarkTools
using JSON

folders_to_test = [
    "basic",
    "random_3x3_matrices_in_-5_5",
    "random_10x10_matrices_in_-1_1",
    "lecture_hall",
    "big_basic",
]

bench_base = "benchmark_data"
result_file = "bench_out.json"

function update_result_file(results::Dict)
    write(result_file, JSON.json(results))
end

bench_results::Dict = Dict()
try
    global bench_results = JSON.parsefile(result_file)
catch
    global bench_results = Dict()
end
for folder in folders_to_test
    # Which ones
    for i in 1:5 # Update this range
        file_key = "$folder-($i)"
        print("Benching $file_key")
        if haskey(bench_results, file_key)
            println(" skipped.")
            continue
        end
        println()
        json_res = JSON.parsefile("$bench_base/$folder/$i.json")
        A_raw = json_res["A"]
        b_raw = json_res["b"]
        e_raw = json_res["E"]
        A = Matrix{Number}(transpose(hcat(A_raw...)))
        b = Vector{Number}(b_raw)
        e = Vector{Bool}(e_raw)
        bench_result = @benchmark solve($A, $b, $e, write_rf_to_out=true, out=devnull)
        bench_results[file_key] = Dict(
            "Adims" => size(A),
            "min" => Dict(
                "time" => BenchmarkTools.prettytime(time(minimum(bench_result))),
                "mem" => BenchmarkTools.prettymemory(time(minimum(bench_result))),
            ),
            "median" => Dict(
                "time" => BenchmarkTools.prettytime(time(median(bench_result))),
                "mem" => BenchmarkTools.prettymemory(time(median(bench_result))),
            ),
            "mean" => Dict(
                "time" => BenchmarkTools.prettytime(time(mean(bench_result))),
                "mem" => BenchmarkTools.prettymemory(time(mean(bench_result))),
            )
        )
        update_result_file(bench_results)
        A_raw = nothing
        b_raw = nothing
        A = nothing
        b = nothing
        GC.gc()
    end
end
