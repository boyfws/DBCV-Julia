using Base.Threads

function bincount(
    arr::Vector{Int64}
    )::Vector{Int64}
    max_val = maximum(arr)
    
    counts = [Atomic{Int}(0) for _ in 1:(max_val + 1)]
    
    @threads for x in arr
        atomic_add!(counts[x + 1], 1)
    end
    
    return [el[] for el in counts]
end