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

# ------------------------------------------------------
# Functions
# ------------------------------------------------------
global max_red, max_green, max_blue
max_red, max_green, max_blue = 12, 13 , 14

function get_game_power(game_str)
    global max_red, max_green, max_blue
    # get game content for each set
    game_sets = split(game_str, ": ")[end]
    game_id = match(r"Game (\d+)", game_str).captures[1]
    sets = split(game_sets, ";")
    # iterate over sets
    min_r, min_g, min_b = Inf, Inf, Inf
    for (iter, set) in enumerate(sets)
        
        r, g, b = extract_colors_quantities(set)
        if iter == 1
            min_r, min_g, min_b = r, g, b
        else
            min_r = r > min_r ? r : min_r
            min_g = g > min_g ? g : min_g
            min_b = b > min_b ? b : min_b
        end

    end
    power = min_r*min_g*min_b
    return power

end

function quantity_dictionary(max_red, max_green, max_blue, r, g, b)
    if r > max_red
        return false
    end
    if g > max_green
        return false
    end
    if b > max_blue
        return false
    end
    return true
end

function extract_colors_quantities(set_str)
    red_re = r"(\d+) red"
    green_re = r"(\d+) green"
    blue_re = r"(\d+) blue"

    r_match = match(red_re, set_str)
    g_match = match(green_re, set_str)
    b_match = match(blue_re, set_str)

    r = r_match !== nothing ? parse(Int, r_match.captures[1]) : 0
    g = g_match !== nothing ? parse(Int, g_match.captures[1]) : 0
    b = b_match !== nothing ? parse(Int, b_match.captures[1]) : 0

    return r, g, b
end

# ------------------------------------------------------
# Main loop 
# -----------------------------------------------------
global feasible_ids_sum
game_powers_sum = 0
open(INPUT_PATH) do f
    global game_powers_sum
    while !eof(f)
        game_line = readline(f)
        #@printf("%s \n", "$game_line")
        game_power = get_game_power(game_line)
        
        game_powers_sum += game_power
        @printf("%s | game power %i | current sum %i\n", game_line, game_power, game_powers_sum)
        
    end
end

println('-'^100)
@printf("Final answer %i ", game_powers_sum)
println()

2683