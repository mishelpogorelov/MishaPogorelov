using HorizonSideRobots
include("functions.jl")
HorizonSideRobots.isborder(robot, side::NTuple{2, HorizonSide}) = (isborder(robot, side[1]) || isborder(robot, side[2]))
HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end
function mark_direct!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n+=1
        putmarker!(robot)
    end
    return n
end
function diagonalcross(robot)
    sides= ((Nord, Ost), (Sud, Ost), (Sud, West), (Nord, West))
    putmarker!(robot)
    for s = sides
        n = mark_direct!(robot, s)
        move!(robot, inverse.(s), n)
        end
        
end
