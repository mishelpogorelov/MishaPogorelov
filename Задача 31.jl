using HorizonSideRobots

include("functions.jl")
struct Coordinates
    x :: Int
    y :: Int
end

mutable struct CoordRobot
    robot :: Robot
    coord :: Coordinates
end

CoordRobot(robot) = CoordRobot(robot, Coordinates(0,0))

struct LabirintRobot
    coord_robot :: CoordRobot
    passed_coords :: Set{Coordinates}
    LabirintRobot(robot ::Robot) = new(CoordRobot(robot), Set{Coordinates}())
end

function HorizonSideRobots.move!(coord :: Coordinates, side)
    side == Nord && return Coordinates(coord.x, coord.y+1)
    side == Sud && return Coordinates(coord.x, coord.y-1)
    side == Ost && return Coordinates(coord.x+1, coord.y)
    side == West && return Coordinates(coord.x-1, coord.y)
end

function HorizonSideRobots.move!(robot :: CoordRobot, side)
    move!(robot.robot, side)
    robot.coord = move!(robot.coord, side)
    if abs(robot.coord.x) == abs(robot.coord.y)
        putmarker!(robot.robot)
    end
end

function trymove!(robot :: CoordRobot, side)
    if !isborder(robot, side)
        move!(robot, side)
    end
end

function HorizonSideRobots.isborder( :: CoordRobot, side)
    isborder(robot, side)
end

function trymove1!(robot, side)
    if isborder(robot, side)
        return false
    else
        trymove!(robot, side)
        return true
    end
end

function borderlabirint_traversal!(lab_robot :: LabirintRobot)
    (lab_robot.coord_robot.coord ∈ lab_robot.passed_coords) && return
    push!(lab_robot.passed_coords, lab_robot.coord_robot.coord)
    for side in (Nord, West, Sud, Ost)
        trymove1!(lab_robot.coord_robot, side) && begin
            borderlabirint_traversal!(lab_robot)
            trymove!(lab_robot.coord_robot, inverse(side))
        end
    end
end
