using Test
using CSV
using DataFrames 


include("../DBCV.jl")



@testset "Тест разных длин" begin

    matrix::Matrix{Float64} = [1 2 3; 4 5 6]

    bad_labels = [1, 1, 1]

    @test_throws AssertionError DBCV(matrix, bad_labels, Vector{Int64}(), "euclidean_squared")


end


@testset "Тест неправильной нормы" begin
    matrix::Matrix{Float64} = [1 2; 2 1]

    labels = [0, 9]

    @test_throws AssertionError DBCV(matrix, labels, Vector{Int64}(), "dadadada")
end



@testset "Тестирование совместимостти со старыми библиотеками" failfast=false begin
    threshold = 0.075  # Порог для сравнения

    test_cases = [
        (1, 0.8576),
        (2, 0.8103),
        (3, 0.6319),
        (4, 0.8688)
    ]

    function load_dataset(number::Int)
        path = joinpath(@__DIR__, "datasets", "dataset_$number.txt")
        df = CSV.read(path, DataFrame; header=false, delim=' ')
        X = Matrix(df[:, 1:2])  # Первые два столбца — признаки
        y = Vector{Int64}(df[:, 3])  # Третий столбец — метки
        return X, y
    end

    for (number, expected) in test_cases
        X, y = load_dataset(number)
        score = DBCV(X, y)
        @test expected * (1 - threshold) <= score <= expected * (1 + threshold)
    end
end