using HorizonSideRobots

include("functions.jl")

function halfdist!(robot, side)
    if  !isborder(robot, inverse(side))
        move!(robot, inverse(side))
        if  !isborder(robot, inverse(side))
            move!(robot, inverse(side))
        else
            return 
        end
    else
        return
    end
    halfdist!(robot, side)
    move!(robot, side)
end

function halfdist_minus!(robot, side)
    isborder(robot, side) && return
    move!(robot, side)
    halfdist_plus!(robot, side)
    end
function halfdist_plus!(robot, side)
    isborder(robot, side) && return
    move!(robot, side)
    halfdist_minus!(robot, side)
    move!(robot, inverse(side))
end
