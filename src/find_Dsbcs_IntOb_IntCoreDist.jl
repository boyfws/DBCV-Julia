include("compCoreDist.jl")
include("MST.jl")
include("binCount.jl")

using LinearAlgebra
using Base.Threads

function find_Dsbcs_IntOb_IntCoreDist(
    matrix::Symmetric{Float64}, 
    index::Vector{Int64},
    d::Int64
    )::Tuple{Float64, Vector{Int64}, Vector{Float64}}
    """
    Находит dsbcs, inernal objects 

    index - массив индексов для элементов кластера
    """
    n::Int64 = length(n)

    core_dists = computeCoreDist(matrix, index, d)

    @threads for i in 1:n
        for j in i:n
            matrix[index[i], index[j]] = max(matrix[index[i], index[j]], core_dists[i], core_dists[j])
        end 

    end 

    # Тут возвращаются индексы для массива index 
    first_index, second_index, weights = MST(matrix, index)

    counts = bincount([first_index; second_index])
    # Длина counts n + 1 так как индекс n точно встретится хоть раз 
    # по опредлению mst 

    # n + 1 соотв n - ому индексу 
    # 1 соотв 0 - ому индексу 

    @assert length(counts) == n - 1 "Проблема при построении mst, элемент с индексом n встречается 0 раз"
    

    bool_mask_int_ob = counts .> 1


    dsbcs = Atomic{Int64}(0)

    @threads for i in 1:length(weights)

        if bool_mask_int_ob[first_index[i] + 1] && bool_mask_int_ob[second_index[i] + 1]
            atomic_min!(dsbcs, weights[i])
        end 

    end


    slice_for_int_ob = view(bool_mask_int_ob, 2:n + 1)

    return dsbcs, index[slice_for_int_ob], core_dists[slice_for_int_ob]
    
end