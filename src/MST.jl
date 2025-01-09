using Base.Threads
using DataStructures

function MST(
    matrix::Symmetric{Float64}, 
    index::Vector{Int64}
    )::Tuple{Vector{Int64}, Vector{Int64}, Vector{Float64}}
    n = size(index, 1)  
    dset = IntDisjointSets(n) 
    
    first_coord::Vector{Int64} = []
    second_coord::Vector{Int64} = []
    weights::Vector{Float64} = []


    # Заранее выделяем память 
    sizehint!(first_coord, n - 1)
    sizehint!(second_coord, n - 1)
    sizehint!(weights, n - 1)

    while length(weights) < n - 1
        min_edges = Dict{Int64, Tuple{Int64, Int64, Float64}}()

        locker = ReentrantLock()

        @threads for u in 1:n
            root_u = find_root(dset, u)
            el_generator = (
                (v, matrix[index[u], index[v]]) for v in u:n if u != v && root_u != find_root(dset, v)
                
            )
            # Мы провеоряем генератор на пустоту, чтобы argmin не выкинул ошибку

            if isempty(el_generator)
                el_generator_checked = ((-1, Inf) for _ in 1:1) 
            else 
                el_generator_checked = el_generator
            end 


            min_el = argmin(
                x -> x[2],
                el_generator_checked
            )
            
            lock(locker) do
                
                if min_el[2] < get!(min_edges, root_u, (-1, -1, Inf))[3]

                    min_edges[root_u] = (u, min_el[1], min_el[2])

                end

            end 
                    
        end

        for value in values(min_edges)
            u, v, weight = value
            if u != -1
                root_u = find_root(dset, u)
                root_v = find_root(dset, v)
                if root_u != root_v

                    push!(first_coord, u)
                    push!(second_coord, v)
                    push!(weights, weight)

                    union!(dset, root_u, root_v)
                    
                end 

            end

        end

    end

    return first_coord, second_coord, weights
end
