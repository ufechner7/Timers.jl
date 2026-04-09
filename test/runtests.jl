using Timers
using Test

cd(dirname(@__DIR__))
println("Running tests in: ", pwd())

@testset "Timers.jl" seed=0 begin
    # include("bench.jl")
    include("test_timers.jl")
end
nothing
