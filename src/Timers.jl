#= MIT License

Copyright (c) 2020, 2021, 2022 Uwe Fechner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. =#

module Timers

export tic, toc, sleep_ms, wait_until

const start = [time_ns()]

function tic()
    start[1] = time_ns()
    nothing
end

function toc(prn=true)
    elapsed=(time_ns() - start[1])/1e9
    if prn
        println("Time elapsed: $elapsed s")
    end
    elapsed
end

@inline function  sleep_ms(time_ms)
    # use the sleep() function only for delays greater than 4ms
    delta1 = 0.004e9
    finish = time_ns() + time_ms*1e6
    # sleep and allow cooperative multitasking
    if (finish - delta1) > time_ns()
        sleep(1e-9*(finish - time_ns() - 0.003e9))
    end
    # busy waiting
    while finish > time_ns()
    end
end

# time in seconds since epoch
@inline function wait_until(finish; always_sleep=false)
    if always_sleep
        sleep(0.001)
    end
    delta1 = 0.002
    delta2 = 0.0002
    if finish - delta1 > time()
        sleep(finish - time() - 0.001)
    end
    # sleep 
    while finish - delta2 > time()
        Base.Libc.systemsleep(delta2)
    end
    # busy waiting
    while finish > time()-0.95e-6
    end
    nothing
end

end
