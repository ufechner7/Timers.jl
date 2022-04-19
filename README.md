# Timers

The package provides the following functions:

## Functions
```tic()```  
Starts a timer

```toc()```  
Returns the time since the timer was started in seconds

```sleep_ms(time_ms)```  
Sleeps for the given number of milli-seconds. Accuracy on Linux better than 100 nanoseconds,
on Windows better than 100 microseconds, but only if the system is not fully loaded.

```wait_until(finish)```  
Sleeps until the given time is reached. Example:
```julia
dt = 0.05
start = time()
for i in 1:100
    # do some work
    wait_until(start + i*dt)
end
```
The section "```# do some work```" is executed exactly every 50ms as long as executing this section takes less than 50ms.
