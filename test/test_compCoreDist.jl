include("../src/compCoreDist.jl")

using Test
using LinearAlgebra


@testset "Тест верности значений" begin
    @testset "Тест 1" begin
        d::Int64 = 2
        matrix::Symmetric{Float64} = Symmetric(
            [Inf 8; 8 Inf]
        )
        index::Vector{Int64} = [1, 2]
        @test isapprox(
            computeCoreDist(matrix, index, d), 
            Vector{Float64}([8, 8])
            )
    end

    @testset "Тест 2" begin
        d::Int64 = 4
        matrix::Symmetric{Float64} = Symmetric(
            [Inf 270; 
            270 Inf]
        )
        index::Vector{Int64} = [1, 2]
        @test isapprox(
            computeCoreDist(matrix, index, d), 
            Vector{Float64}([270, 270])
            )
    end


    @testset "Тест 3" begin
        d::Int64 = 2
        matrix::Symmetric{Float64} = Symmetric(
            [Inf 7.4 10.09 0.85; 
            7.4 Inf 9.97 3.37; 
            10.09 9.97 Inf 9.68; 
            0.85 3.37 9.68 Inf]
        )
        index::Vector{Int64} = [1, 2, 3, 4]
        @test isapprox(
            computeCoreDist(matrix, index, d), 
            Vector{Float64}([1.45753035, 5.07729849, 9.90880329, 1.42238861])
            )
    end


    @testset "Тест 4" begin
        d::Int64 =3
        matrix::Symmetric{Float64} = Symmetric(
            [Inf 3 12;
            3 Inf 3; 
            12 3 Inf]
        )
        index::Vector{Int64} = [1, 2, 3]
        @test isapprox(
            computeCoreDist(matrix, index, d), 
            Vector{Float64}([3.76027949, 3.0, 3.76027949])
            )
    end


end
