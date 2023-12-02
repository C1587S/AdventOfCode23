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

function get_game_feasibility(game_str)
    global max_red, max_green, max_blue
    # get game content for each set
    game_sets = split(game_str, ": ")[end]
    game_id = match(r"Game (\d+)", game_str).captures[1]
    sets = split(game_sets, ";")
    # iterate over sets
    for set in sets
        
        r, g, b = extract_colors_quantities(set)
        feasible = quantity_dictionary(max_red, max_green, max_blue, r, g, b)

        if !feasible
            return 0
        end
    end

    return parse(Int64, game_id)

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
feasible_ids_sum = 0
open(INPUT_PATH) do f
    global feasible_ids_sum
    while !eof(f)
        game_line = readline(f)
        #@printf("%s \n", "$game_line")
        game_id_int = get_game_feasibility(game_line)
        
        feasible_ids_sum += game_id_int
        if game_id_int!= 0
            @printf("Game ID%s | current sum %i\n", game_id_int, feasible_ids_sum)
        end
    end
end

#49710

println('-'^100)
@printf("Final answer %i ", feasible_ids_sum)
println()

2683