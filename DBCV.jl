include("src/prepareData.jl")
include("src/calcDBCV.jl")
 



function DBCV(
    data:: Matrix{Float64}, 
    labels::Vector{Int64}, 
    noise_id::Vector{Int64} = [-1], 
    norm::String = "euclidean_squared"
    )::Float64
    # В рамках функции работаем с представлениям для экономии памяти - представления неизменяемы и доступны 
    # только для чтения

    # Предполгается, что длина data и labels равна
    @assert size(data, 1) == length(labels) "Каждому наблюдению должна соответсвовать одна метка"
    n::Int64 = size(data, 1)

    return calcDBCV(prepareData(data, labels, noise_id, norm)...) / n 

end

