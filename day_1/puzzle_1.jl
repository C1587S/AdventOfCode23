using Printf

# Parameters
INPUT_PATH = "/mnt/c/Users/scada/git/personal/AdventOfCode23/day_1/input2.txt"

# 0. Function to get calibration value
# ------------------------------------------------------
function get_calibration_val(txt, verbose=true)
    # Find sequences of digits in the text
    matches = collect(eachmatch(r"\d+", txt)) # note: matches find non separated integers e.g. 12, 48, ...

    if !isempty(matches)
        f_i = matches[1].match[1] # first int 
        l_i = matches[end].match[end] # lat int
        # convert string to int
        first_int = parse(Int64, f_i)
        last_int = parse(Int64, l_i)

        # Calculate the sum
        sum_int = first_int + last_int
        if verbose
            @printf("%s: %i - %i, Sum: %i\n", txt, first_int, last_int, sum_int)
        end
        return sum_int
    else
        if verbose
            println("No digits found in: ", txt)
        end
        return 0
    end
end

# ------------------------------------------------------
# Main loop 
global total_sum
total_sum = 0
open(INPUT_PATH) do f
    global total_sum
    while !eof(f)
        s = readline(f)
        int_sum = get_calibration_val("$s", true)
        total_sum += int_sum
        @printf("Current sum %i ", total_sum)
        println()
    end
end

println('-'^100)
@printf("Final answer %i ", total_sum)
println()
