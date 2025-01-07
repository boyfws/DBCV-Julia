function GetOneTimeOccurenceSet(
    labels::Vector{Int64}
    )::Set{Int64}

    first_time_occurence =  Set{Int64}()
    few_time_occurence =  Set{Int64}()

    for el in labels
        if el in few_time_occurence
            continue
        elseif el in first_time_occurence

            push!(few_time_occurence, el)
            pop!(first_time_occurence, el, nothing)  # Ничего не произойдёт, так как 5 нет в множестве

        else

            push!(first_time_occurence, el)

        end 

    end
    
    return first_time_occurence
end


function getBadLabelsMask(
    labels::Vector{Int64}, 
    noise_id::Vector{Int64}
    )::Vector{Bool}
    one_occur_set = GetOneTimeOccurenceSet(labels)

    bad_labels = union(one_occur_set, Set(noise_id))

    return [!(el in bad_labels) for el in labels]
    
end