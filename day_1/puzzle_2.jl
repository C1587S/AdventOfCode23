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
function map2number(int_str, position)
    str_int = lowercase(int_str)

    # if integer return, else map2number
    if all(isdigit, str_int)
        int = parse(Int64, str_int)
        # only the first digit
        if length(str_int) > 1
            if position == "end"
                r_int = mod(int, 10)
                return string(r_int)
            elseif  position == "start" 
                return string(str_int[1:1])
            end
        else
            return string(int)
        end
    else
        numbers_dict = Dict(
            "one" => "1",
            "two" => "2",
            "three" => "3",
            "four" => "4",
            "five" => "5",
            "six" => "6",
            "seven" => "7",
            "eight" => "8",
            "nine" => "9",
        )
        # check if key exists
        if haskey(numbers_dict, str_int)
            return numbers_dict[str_int]
        else
            error("No key found!")
        end

    end
end

function get_calibration_val(txt, verbose=true)
    # Find sequences of digits in the text
    regexes = [r"one", r"two", r"three", r"four", r"five", r"six", r"seven", r"eight", r"nine", r"\d+"]
    matches = []
    for regex in regexes
        append!(matches, collect(eachmatch(regex, txt)))
    end

    sort!(matches, by=m->m.offset) # order by match index

    first_match_mapped = map2number(matches[1].match, "start")
    last_match_mapped = map2number(matches[end].match, "end")
    # prints for debuging
    @printf("%s (%s | %s)\n", txt, first_match_mapped, last_match_mapped)

    if !isempty(matches)
        j_st = first_match_mapped * last_match_mapped
        join_int = parse(Int64, j_st)
        # Calculate the sum
        if verbose
            @printf("%s: join number %i\n", txt, join_int)
        end
        return join_int 
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
    @printf("Current sum %i \n", total_sum)
    while !eof(f)
        s = readline(f)
        int_sum = get_calibration_val("$s", true)
        total_sum += int_sum
        @printf("Current sum %i \n", total_sum)
        println()
    end
end

println('-'^100)
@printf("Final answer %i ", total_sum)
println()
