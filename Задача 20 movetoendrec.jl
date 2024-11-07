using HorizonSideRobots
include("functions.jl")
function movetoendrec!(robot, side)
    if !isborder(robot, side)
        move!(robot, side) 
        !isborder(robot, side) &&movetoendrec!(robot,side)
    else
        putmarker!(robot)
        return nothing
    end
    if isborder(robot, side)   
        putmarker!(robot)
    end
    move!(robot, inverse(side))
end
