using HorizonSideRobots

struct Coordinates
    x :: Int
    y :: Int
end

mutable struct CoordChessRobot
    robot :: Robot
    coord :: Coordinates
    flag :: Bool
end

CoordChessRobot(robot) = CoordChessRobot(robot, Coordinates(0,0), true)

struct LabirintRobot
    coord_robot:: CoordChessRobot
    passed_coords::Set{Coordinates}
    LabirintRobot(robot :: Robot) = new(CoordChessRobot(robot), Set{Coordinates}())
end

function HorizonSideRobots.move!(coord::Coordinates, side :: HorizonSide)
    side == Nord && return Coordinates(coord.x, coord.y+1)
    side == Sud && return Coordinates(coord.x, coord.y-1)
    side == Ost && return Coordinates(coord.x+1, coord.y)
    side == West && return Coordinates(coord.x-1, coord.y)
end

function HorizonSideRobots.move!(robot::CoordChessRobot, side)
    move!(robot.robot, side)
    robot.coord = move!(robot.coord, side)
    if robot.flag == true
        putmarker!(robot.robot)
    end
    robot.flag = !robot.flag
end

function HorizonSideRobots.isborder(::CoordChessRobot, side)
    isborder(robot, side)
end

function trymove!(robot, side)
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)

function borderlabirint_traversal!(lab_robot :: LabirintRobot)
    (lab_robot.coord_robot.coord ∈ lab_robot.passed_coords) && return
    push!(lab_robot.passed_coords, lab_robot.coord_robot.coord)
    for side in (Nord, West, Sud, Ost)
        trymove!(lab_robot.coord_robot, side) && begin
            borderlabirint_traversal!(lab_robot)
            move!(lab_robot.coord_robot, inverse(side))
        end
    end
end
