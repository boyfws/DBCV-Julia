include("calcNumOccur.jl")
include("find_Dsbcs_IntOb_IntCoreDist.jl")
include("findIndex.jl")
include("findMinDspcs.jl")

using LinearAlgebra
using Base.Threads

function calcDBCV(
    matrix::Symmetric{Float64}, 
    labels::SubArray{Int64, 1},
    d::Int64
    )::Float64

    # 0 Если у нас нет элементов 
    if length(labels) == 0
        return Float64(0)
    end 

    unique_values, counts_for_unique = calcNumOccur(labels)

    # если у нас один - то мы ничего не посчитаем 
    uniq_val_len = length(unique_values)

    if uniq_val_len == 1
        return Float64(0)
    end 

    # Инициализируем переменные 
    dsbcs::Vector{Float64} = fill(Float64(0), uniq_val_len)

    min_dspcs::Vector{Float64} = fill(Float64(Inf), uniq_val_len)

    internal_objects_per_cls = Dict{Int64, Vector{Int64}}()

    internal_core_dists = Dict{Int64, Vector{Float64}}()


    for i in 1:uniq_val_len
        index::Vector{Int64} = findIndex(labels, unique_values[i])

        dsbcs[i], internal_objects_per_cls[i], internal_core_dists[i] = find_Dsbcs_IntOb_IntCoreDist(matrix, index, d)

    end 


    for i in 1:uniq_val_len

        for j in i+1:uniq_val_len
            new_val_for_min_dscps = findMinDspcs(
                matrix, 
                internal_objects_per_cls[i], 
                internal_objects_per_cls[j], 
                internal_core_dists[i], 
                internal_core_dists[j]
            )


            min_dspcs[i] = min(min_dspcs[i], new_val_for_min_dscps)
            min_dspcs[j] = min(min_dspcs[j], new_val_for_min_dscps)



        end

    end


    min_dspcs = replace(min_dspcs, NaN => 0.0, Inf => 2^63 - 1, -Inf => -(2^63 - 1))

    vcs = (min_dspcs .- dsbcs) ./ (1e-12 .+ max.(min_dspcs, dsbcs))

    vcs = replace(vcs, NaN => 0.0, Inf => 2^63 - 1, -Inf => -(2^63 - 1))
    
    return sum(vcs .* counts_for_unique)

end 