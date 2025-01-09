using LinearAlgebra
using Base.Threads

function createDistMatrix(data::AbstractMatrix{Float64}, norm::Function)::Symmetric{Float64}
    n::Int = size(data, 1)
    dist_matrix_upper = Symmetric(zeros(Float64, n, n), :U)

    @threads for i in 1:n
        for j in i:n
            if i != j
                dist_matrix_upper.data[i, j] = norm(data[i, :], data[j, :])
            else 
                dist_matrix_upper.data[i, j] = Inf
            end

        end 

    end  

    return dist_matrix_upper

end