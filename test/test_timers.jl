using Pkg
if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    Pkg.activate(@__DIR__)
end

using Test
using Timers

@testset "test_timers" seed=0 begin
    tic()
    t0 = toc(false)
    @test t0 >= 0.0

    t_start = time_ns()
    sleep_ms(2.0)
    elapsed_ms = (time_ns() - t_start) / 1e6
    @test elapsed_ms >= 1.0

    finish_ns = time_ns() + 3_000_000
    wait_until(finish_ns)
    @test time_ns() >= finish_ns
end
nothing
