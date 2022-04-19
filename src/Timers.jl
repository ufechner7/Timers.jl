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

const start = [time()]

function tic()
    start[1] = time()
end

function toc()
    time() - start[1]
end

@inline function  sleep_ms(time_ms)
    delta = 0.0002
    finish = time() + time_ms/1000.0
    # sleep
    if time_ms > 1000.0 * delta
        Base.Libc.systemsleep(time_ms/1000.0 - delta)
    end
    # busy waiting
    while finish > time()-0.95e-6
    end
end

# time in seconds since epoch
@inline function wait_until(finish)
    delta = 0.0002
    # sleep 
    while finish - delta > time()
        Base.Libc.systemsleep(delta)
    end
    # busy waiting
    while finish > time()-0.95e-6
    end
    nothing
end

end
