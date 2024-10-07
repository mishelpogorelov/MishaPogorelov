using HorizonSideRobots
include("functions.jl")
function go_back!(robot)
    move!(robot, Nord)
    untildawn(robot, West)
end
function line!(robot, n, N)
    k = 0
    if div(n, N)%2 == 0
        while !isborder(robot, Ost)
            if div(k, N)%2 == 0
                putmarker!(robot)
                move!(robot, Ost)
                k+=1
            elseif div(k, N)%2 == 1
                move!(robot, Ost)
                k+=1
            end
        end
        if div(k, N)%2 == 0
            putmarker!(robot)
        end
    elseif div(n, N)%2 == 1
        while !isborder(robot, Ost)
            if div(k, N)%2 == 1
                putmarker!(robot)
                move!(robot,Ost)
                k+=1
            elseif div(k, N)%2 == 0
                move!(robot, Ost)
                k+=1
            end
        end
        if div(k, N)%2 == 1
            putmarker!(robot)
        end
    end
end

function chess_N(robot, N)
    num_steps_West = untildawn(robot, West)
    num_steps_Sud = untildawn(robot, Sud)
    n = 0
    while true
        line!(robot, n, N)
        if isborder(robot, Nord)
            break
        end
        go_back!(robot)
        n+=1
    end
    untildawn(robot, West)
    untildawn(robot, Sud)
    move!(robot, Nord, num_steps_Sud)
    move!(robot, Ost, num_steps_West)
end
