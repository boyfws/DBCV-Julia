using LinearAlgebra
using Base.Threads

function computeCoreDist(
    dist_matrix::Symmetric{Float64}, 
    index::Vector{Int64}, 
    d::Int64
    )::Vector{Float64}

    n::Int64 = length(index)

    core_dists::Vector{Float64} = zeros(Float64, n)

    @threads for i in 1:n 
        core_dists[i] = sum(dist_matrix[index[i], index[j]] ^ -d for j in 1:n) / (n - 1)
            
    end

    return core_dists .^ (-1 / d)

end