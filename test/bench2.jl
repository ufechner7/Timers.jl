using Pkg
if ! ("BenchmarkTools" ∈ keys(Pkg.project().dependencies))
    using TestEnv; TestEnv.activate()
end
using Timers, BenchmarkTools

function test_wait_until(delta_t_ms)
    until_ms = 1e-6*time_ns()+delta_t_ms
    wait_until(1e6*until_ms)
end

# Define a parent BenchmarkGroup to contain our suite
suite = BenchmarkGroup()

# Add some child groups to our benchmark suite. The most relevant BenchmarkGroup constructor
# for this case is BenchmarkGroup(tags::Vector). These tags are useful for
# filtering benchmarks by topic, which we'll cover in a later section.
suite["wait_until"] = BenchmarkGroup(["sleep_ms"])

# Add some benchmarks to the "sleep_ms" group
suite["wait_until"]["100µs"] = @benchmarkable test_wait_until(0.1)
suite["wait_until"]["200µs"] = @benchmarkable test_wait_until(0.2)
suite["wait_until"]["500µs"] = @benchmarkable test_wait_until(0.5)
suite["wait_until"]["1ms"] = @benchmarkable test_wait_until(1.0)
suite["wait_until"]["2ms"] = @benchmarkable test_wait_until(2.0)
suite["wait_until"]["5ms"] = @benchmarkable test_wait_until(5.0)
suite["wait_until"]["10ms"] = @benchmarkable test_wait_until(10.0)

tune!(suite);
results = run(suite, seconds = 1)
m3 = mean(results["wait_until"])

