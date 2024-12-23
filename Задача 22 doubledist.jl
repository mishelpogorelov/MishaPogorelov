using HorizonSideRobots
include("functions.jl")

function doubledist!(robot, side)
    isborder(robot, inverse(side)) && return
    move!(robot, inverse(side))
    doubledist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        if !isborder(robot, side)
            move!(robot, side)
            return true
        else
            return false
        end
    else
        return false
    end
end

function doubledist1!(robot, side)
    isborder(robot, inverse(side))&& return
    move!(robot, inverse(side))
    doubledist1!(robot, side)
    if !isborder(robot, side) && !ismarker(robot)
        move!(robot, side)
        if !isborder(robot, side) && !ismarker(robot)
            move!(robot, side)
            return true
        end
    else
        move!(robot, inverse(side))
        putmarker!(robot)
    end
end


function numstepstolimit!(robot, side)
    isborder(robot, side) && return 0
    move!(robot, side)
    return numstepstolimit!(robot, side) + 1
end
    
function attemptmove!(robot, side, max_num_steps::Integer, num_steps =0 ::Integer)
    max_num_steps == 0 && return num_steps
    if trymove!(robot, side)
        return attemptmove!(robot, side, max_num_steps - 1, num_steps+ 1)
    else
        return num_steps
    end
end
function trymove!(robot, side)
    isborder(robot, side) && return false
    move!(robot, side)
    return true
end
    
function trydoubledist!(robot, side)
    n = numstepstolimit!(robot, side)
    m = attemptmove!(robot, inverse(side), 2n)
    if m == 2n
        return true
    else
        move!(robot, side, m-n)
        return false
    end
end
