using Printf
using ArgParse

# Parameters
s = ArgParseSettings()
@add_arg_table s begin
    "input_path"
    required = true
end
parsed_args = parse_args(ARGS, s)
INPUT_PATH = get(parsed_args, "input_path", "")

if isempty(INPUT_PATH)
    println("Error: The input path is missing!")
    exit(1)
end

# 0. Function to get calibration value
# ------------------------------------------------------
function get_calibration_val(txt, verbose=true)
    # Find sequences of digits in the text
    matches = collect(eachmatch(r"\d+", txt)) # note: matches find non separated integers e.g. 12, 48, ...

    if !isempty(matches)
        f_i = matches[1].match[1] # first int 
        l_i = matches[end].match[end] # lat int
        j_st = f_i * l_i
        join_st = parse(Int64, j_st)
        # Calculate the sum
        if verbose
            @printf("%s: join number%i\n", txt, join_st)
        end
        return join_st #sum_int
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
