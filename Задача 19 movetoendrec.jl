using HorizonSideRobots
function movetoendrec!(robot, side)
    !isborder(robot, side) && (move!(robot,side); movetoendrec!(robot,side))
    return nothing
end
