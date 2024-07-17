using JSON

function latte_to_json(in::IO, out::IO)
    lines = readlines(in)
    header = split(lines[1])
    lines = lines[2:end]
    linearity = []
    nonnegative = []
    lines = filter!(line -> begin
            tokens = split(line)
            if tokens[1] == "linearity"
                linearity = parse.(Int, tokens[3:end])
                return false
            elseif tokens[1] == "nonnegative"
                nonnegative = parse.(Int, tokens[3:end])
                return false
            end
            true
        end, lines)
    A, b = [], []
    for line in lines
        tokens = split(line)
        push!(b, -parse(Int, tokens[1]))
        push!(A, parse.(Int, tokens[2:end]))
    end
    E = zeros(Int, parse(Int, header[1]))
    for i in linearity
        E[i] = 1
    end
    JSON.print(out, Dict("A" => A, "b" => b, "E" => E))
end

function json_to_latte(in::IO, out::IO)
    definition = JSON.parse(in)
    lines = ["$(length(definition["b"])) $(1 + length(definition["A"][1]))"]
    for e in 1:length(definition["A"])
        push!(lines, join(["$(definition["b"][e])" .* -1; [string(i) for i in definition["A"][e]]...], " "))
    end
    linearity_indices = [i for (i, e) in enumerate(definition["E"]) if e != 0]
    push!(lines, "linearity $(sum(definition["E"])) " * join([string(i) for i in linearity_indices], " "))
    push!(lines, "nonnegative " * join([string(i) for i in 1:length(definition["A"][1])], " "))
    for line in lines
        write(out, line * "\n")
    end
end
