include("calcNumOccur.jl")
include("find_Dsbcs_IntOb_IntCoreDist.jl")
include("findIndex.jl")

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
        index::Vector{Int64} = findIndex(labels, uniq_val_len[i])

        dsbcs[i], internal_objects_per_cls[i], internal_core_dists[i] = find_Dsbcs_IntOb_IntCoreDist(matrix, index, d)

    end 


    for i in 1:uniq_val_len

        for j in i+1:uniq_val_len


        end

    end



    






end 