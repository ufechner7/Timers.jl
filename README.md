# Timers

The package provides the following functions:

## Functions
```tic()```  
Starts a timer

```toc(prn=true)```  
Print the time in seconds since tic() was called. To suppress the printed output
use `toc(false)`. 

Returns the time since the timer was started in seconds.

```sleep_ms(time_ms)```  
Sleeps for the given number of milli-seconds. Accuracy on Linux better than 100 nanoseconds +-0.2%, but only if the system is not fully loaded. On Linux for delays larger than 4ms sleep() is used, on Windows for delays larger than 16 ms.

```wait_until(finish; always_sleep=false)```  
Sleeps until the given time [ns] is reached. Example:
```julia
dt = 0.05
start = time_ns()
for i in 1:100
    # do some work
    wait_until(start + i*dt*1e9)
end
```
The section "```# do some work```" is executed exactly every 50ms as long as executing this section takes less than 50ms.

The additional parameter always_sleep can be set to true if you want to ensure that the sleep function
is always called for at least 1 ms. This is useful if you need to ensure that cooperative multitasking
works even for the price to miss the deadline.

## Test results
Comparison of the desired and actual sleep time for the functions sleep() and sleep_ms():

OS: Ubuntu 18.04 with a i7-7700K CPU and the standard kernel version 5.4.0-87-generic.
```julia
julia> include("test/bench.jl")
7-element BenchmarkTools.BenchmarkGroup:
  tags: ["sleep_ms"]
  "100µs" => TrialEstimate(100.152 μs)
  "200µs" => TrialEstimate(200.108 μs)
  "5ms" => TrialEstimate(5.000 ms)
  "1ms" => TrialEstimate(1.000 ms)
  "10ms" => TrialEstimate(10.001 ms)
  "500µs" => TrialEstimate(500.093 μs)
  "2ms" => TrialEstimate(2.000 ms)
4-element BenchmarkTools.BenchmarkGroup:
  tags: ["sleep"]
  "5ms" => TrialEstimate(6.255 ms)
  "1ms" => TrialEstimate(2.219 ms)
  "10ms" => TrialEstimate(11.215 ms)
  "2ms" => TrialEstimate(3.199 ms)
```
This are the mean values. The error of the sleep_ms function is below 0.1% +- 100ns. The error of the default sleep() function of Julia is between 1ms and 2ms, for the set values of 1ms to 10ms this is an error of 13% to 62%.