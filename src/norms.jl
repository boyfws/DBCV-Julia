module Norms
    function euclidean_squared(x::Vector{Float64}, y::Vector{Float64})::Float64
        return sum((x - y) .^ 2)
    end   
    
    export euclidean_squared

end 
