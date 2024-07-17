using PolyhedralOmega
using BenchmarkTools
using JSON

SIMPLIFY = true

raw_data = JSON.parsefile(ARGS[1])
A_raw = raw_data["A"]
b_raw = raw_data["b"]
e_raw = raw_data["E"]
A = Matrix{Number}(transpose(hcat(A_raw...)))
b = Vector{Number}(b_raw)
e = Vector{Bool}(e_raw)
println("A: $(A)")
println("b: $(b)")
println("e: $(e)")
println("---")
for i in 1:size(A, 1)
    if e[i]
        println(A[i, :], " == ", b[i])
    else
        println(A[i, :], " <= ", b[i])
    end
end
println("---")
if SIMPLIFY
    res = solve(A, b, e)
    print(PolyhedralOmega.evaluate(res[3]))
else
    solve(A, b, e, write_rf_to_out=true)
end
println()
