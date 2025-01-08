include("getNormByName.jl")
include("getBadLabelsMask.jl")
include("createDistMatrix.jl")


function prepareData( 
    data:: Matrix{Float64}, 
    labels::Vector{Int64}, 
    noise_id::Vector{Int64}, 
    norm::String
    )::Tuple{Symmetric{Float64}, SubArray{Int64, 1}, Int64}
    
    d::Int64 = size(data, 2)

    norm_func = getNormByName(norm)
    @assert norm_func !== nothing "Передано неправильное имя функции"

    mask = getBadLabelsMask(labels, noise_id)

    new_labels = @view labels[mask]
    new_data = @view data[mask, :]

    dist_matrix = createDistMatrix(new_data, norm)


    return dist_matrix, new_labels, d
    
end