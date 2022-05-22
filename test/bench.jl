using Pkg
if ! ("BenchmarkTools" ∈ keys(Pkg.project().dependencies))
    using TestEnv; TestEnv.activate()
end
using Timers, BenchmarkTools

# Define a parent BenchmarkGroup to contain our suite
suite = BenchmarkGroup()

# Add some child groups to our benchmark suite. The most relevant BenchmarkGroup constructor
# for this case is BenchmarkGroup(tags::Vector). These tags are useful for
# filtering benchmarks by topic, which we'll cover in a later section.
suite["sleep_ms"] = BenchmarkGroup(["sleep_ms"])
suite["sleep"] = BenchmarkGroup(["sleep"])

# Add some benchmarks to the "sleep_ms" group
suite["sleep_ms"]["100µs"] = @benchmarkable sleep_ms(0.1)
suite["sleep_ms"]["200µs"] = @benchmarkable sleep_ms(0.2)
suite["sleep_ms"]["500µs"] = @benchmarkable sleep_ms(0.5)
suite["sleep_ms"]["1ms"] = @benchmarkable sleep_ms(1.0)
suite["sleep_ms"]["2ms"] = @benchmarkable sleep_ms(2.0)
suite["sleep_ms"]["5ms"] = @benchmarkable sleep_ms(5.0)
suite["sleep_ms"]["10ms"] = @benchmarkable sleep_ms(10.0)

suite["sleep"]["1ms"] = @benchmarkable sleep(1.0e-3)
suite["sleep"]["2ms"] = @benchmarkable sleep(2.0e-3)
suite["sleep"]["5ms"] = @benchmarkable sleep(5.0e-3)
suite["sleep"]["10ms"] = @benchmarkable sleep(10.0e-3)
suite["sleep"]["20ms"] = @benchmarkable sleep(20.0e-3)

tune!(suite);
results = run(suite, seconds = 1)
m1 = mean(results["sleep_ms"])
m2 = mean(results["sleep"])
show(m1);println();show(m2);println()
