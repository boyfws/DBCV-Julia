using DataStructures

function calcNumOccur(
    data::Vector{Int64}
    )::Tuple{Vector{Int64}, Vector{Int64}}

    counter = OrderedDict{Int64, Int64}()

    for el in data
        counter[el] = get(counter, el, 0) + 1
    end

    return collect(keys(counter)), collect(values(counter))
        
    
end