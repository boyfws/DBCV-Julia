using LinearAlgebra
using Base.Threads

function findMinDspcs(
    matrix::Symmetric{Float64}, 
    int_ob_1::Vector{Int64}, 
    int_ob_2::Vector{Int64},
    int_core_dist_1::Vector{Float64},
    int_core_dist_2::Vector{Float64}
    )::Float64
    if length(int_ob_1) == 0 || length(int_ob_2) == 0   
        return Inf
    end 

    if length(int_ob_1) > length(int_ob_2)
        a, b = int_ob_1, int_ob_2
        a_cd, b_cd = int_core_dist_1, int_core_dist_2
    else
        a, b = int_ob_2, int_ob_1
        a_cd, b_cd = int_core_dist_2, int_core_dist_1

    end 

    min_dspcs = Atomic{Float64}(Inf)

    @threads for i in 1:length(a)

        values = [
            matrix[a[i], b[j]] for j in 1:length(b)
        
            ]
        min_values = max.(values, b_cd)
        min_values = max.(min_values, a_cd[i])

        atomic_min!(min_dspcs, minimum(min_values))


    end 

    return min_dspcs[]



end