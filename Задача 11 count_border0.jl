using HorizonSideRobots 
include("functions.jl")

function find_hole(robot, side_up, side)
    
    while isborder(robot, side_up) && !isborder(robot, side)
        move!(robot, side)
    end

    trymove!(robot, side_up)
end

function trymove!(robot, side_up)
    if !isborder(robot, side_up)
        move!(robot, side_up)
        return true
    else
        return false
    end
end


function border_in_string(robot)
    count_b = []
    b = 0

    while !isborder(robot, Ost)
    

        if isborder(robot, Sud)
            push!(count_b, 1)
        end

        if  !isborder(robot, Sud)
            push!(count_b, 0)

        end

        move!(robot, Ost)

    end

    if isborder(robot, Sud)
        push!(count_b, 1)
    else
        push!(count_b, 0)
    end

    push!(count_b, 0)

    for i in eachindex(count_b[1:end-1])#1:length(border_in_string(robot))
        if count_b[i] == 1 && count_b[i+1] == 0
            b += 1
        end
    end

    b += count_b[end]

    untildawn(robot, West)

    return b
end


function count_border(robot)
    k = 0
    untildawn(robot, West)
    while !isborder(robot, Nord) || !isborder(robot, Ost)

        flag = find_hole(robot, Nord, Ost)
        untildawn(robot, West)

        if !flag
            break
        end

    end

    while !isborder(robot, Sud) || !isborder(robot, Ost)
        k += border_in_string(robot)
        flag = find_hole(robot, Sud, Ost)
        untildawn(robot, West)

        if !flag 
            break
        end
    
    end
    
    return k - 1
end
