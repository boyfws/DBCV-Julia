include("norms.jl")
using .Norms            



function getNormByName(norm_name::String)::Union{Function, Nothing}
    if norm_name == "euclidean_squared"
        return Norms.euclidean_squared
    end 

    return nothing
end