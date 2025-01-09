# Нужно провести ресерч для  опредления границы
const BOUND_FOR_PAR_EXEC = 100

function findIndex(labels::AbstractVector{Int64}, el::Int64)::Vector{Int64}
    """
    Функция для нахождения индексов вхождений оопредленного элемента 
    """
    n = length(labels)
    if n < BOUND_FOR_PAR_EXEC
        return Vector{Int64}([j for j in 1:n if labels[j] == el])
    end 

    index = Vector{Int64}()
    locker = ReentrantLock()  # Для синхронизации доступа к массиву

    @threads for j in 1:n
        if labels[j] == el
            lock(locker) do
                push!(index, j)
            end
        end
    end
    return index
end