using HorizonSideRobots


struct Coordinates
    x::Int
    y::Int
end

mutable struct CoordRobot
    robot::Robot
    coord::Coordinates
end
struct LabirintRobot
    coord_robot::CoordRobot
    passed_coords::Set{Coordinates} # - множество с координатами
    LabirintRobot(robot::Robot) = new(CoordRobot(robot), Set{Coordinates}())
end

CoordRobot(robot) = CoordRobot(robot, Coordinates(0,0))

function trymove!(robot, side)
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
function HorizonSideRobots.isborder(robot::LabirintRobot, side)
    return isborder(robot.robot, side)
end

function HorizonSideRobots.isborder(robot::CoordRobot, side)
    return isborder(robot.robot, side)
end
HorizonSideRobots.move!(robot::CoordRobot, side) = begin
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
end

function move(coord::Coordinates, side::HorizonSide)
    side == Nord && return Coordinates(coord.x, coord.y+1)
    side == Sud && return Coordinates(coord.x, coord.y-1)
    side == Ost && return Coordinates(coord.x+1, coord.y)
    side == West && return Coordinates(coord.x-1, coord.y)
end
function HorizonSideRobots.move!(robot::LabirintRobot, side)
    return move!(robot.robot, side)
end
function borderlabirint_traversal!(actions::Function, lab_robot::LabirintRobot)
    (lab_robot.coord_robot.coord ∈ lab_robot.passed_coords) && return
    push!(lab_robot.passed_coords, lab_robot.coord_robot.coord)
    actions()
    for side ∈ (Nord, West, Sud, Ost)
        trymove!(lab_robot.coord_robot, side) && begin
            borderlabirint_traversal!(actions, lab_robot)
            move!(lab_robot.coord_robot, inverse(side))
        end
    end
end

