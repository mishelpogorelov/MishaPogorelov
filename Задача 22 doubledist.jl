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
