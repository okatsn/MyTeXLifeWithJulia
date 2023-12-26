# Please refer to the startup.jl in okatsn/MyJuliaSpace
atreplinit() do repl
    try
        @eval using OhMyREPL, TerminalPager
    catch e
        @warn "error while importing OhMyREPL" e
    end
end

using OkStartUp
