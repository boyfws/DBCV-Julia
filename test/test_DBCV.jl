using Test
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
