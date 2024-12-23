using HorizonSideRobots
using HorizonSideRobots
#Задача 11
include("functions.jl")

function find_hole1(robot, side_up, side)
    
    while isborder(robot, side_up) && !isborder(robot, side)
        move!(robot, side)
    end

    trymove1!(robot, side_up)
end

function trymove1!(robot, side_up)
    if !isborder(robot, side_up)
        move!(robot, side_up)
        return true
    else
        return false
    end
end


function border_in_string1(robot)
    count_b = []
    b = 0

    while !isborder(robot, Ost)
    

        if isborder(robot, Sud)
            push!(count_b, 1)
        end

        if  !isborder(robot, Sud)
            push!(count_b, 0)

        end

        move!(robot, Ost)

    end

    if isborder(robot, Sud)
        push!(count_b, 1)
    else
        push!(count_b, 0)
    end

    push!(count_b, 0)

    for i in eachindex(count_b[1:end-1])#1:length(border_in_string(robot))
        if count_b[i] == 1 && count_b[i+1] == 0
            b += 1
        end
    end

    b += count_b[end]

    untildawn(robot, West)

    return b
end


function count_border0(robot)
    k = 0
    n = untildawn(robot, West)
    m = untildawn(robot, Sud)
    while !isborder(robot, Nord) || !isborder(robot, Ost)

        flag = find_hole1(robot, Nord, Ost)
        untildawn(robot, West)

        if !flag
            break
        end

    end

    while !isborder(robot, Sud) || !isborder(robot, Ost)
        k += border_in_string1(robot)
        flag = find_hole1(robot, Sud, Ost)
        untildawn(robot, West)

        if !flag 
            break
        end
    
    end
    untildawn(robot, West)
    untildawn(robot, Sud)
    move!(robot, Nord, m)
    move!(robot, Ost, n)
    return k - 1
end
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 12
using HorizonSideRobots 
include("functions.jl")

function find_hole(robot, side_up, side)
    
    while isborder(robot, side_up) && !isborder(robot, side)
        move!(robot, side)
    end

    trymove2!(robot, side_up)
end

function trymove2!(robot, side_up)
    if !isborder(robot, side_up)
        move!(robot, side_up)
        return true
    else
        return false
    end
end


function border_in_string(robot)
    count_b = []
    b = 0

    while !isborder(robot, Ost)
    

        if isborder(robot, Sud)
            push!(count_b, 1)
        end

        if  !isborder(robot, Sud)
            push!(count_b, 0)

        end

        move!(robot, Ost)

    end

    if isborder(robot, Sud)
        push!(count_b, 1)
    else
        push!(count_b, 0)
    end

    push!(count_b, 0)
    push!(count_b, 0)

    for i in eachindex(count_b[1:end-2])#1:length(border_in_string(robot))
        if count_b[i] == 1 && count_b[i+1] == 0 && count_b[i+2] == 0
            b += 1
        end
    end

    b += count_b[end]

    untildawn(robot, West)

    return b
end


function count_border(robot)
    k = 0
    n = untildawn(robot, West)
    m = untildawn(robot, Sud)
    while !isborder(robot, Nord) || !isborder(robot, Ost)

        flag = find_hole(robot, Nord, Ost)
        untildawn(robot, West)

        if !flag
            break
        end

    end

    while !isborder(robot, Sud) || !isborder(robot, Ost)
        k += border_in_string(robot)
        flag = find_hole(robot, Sud, Ost)
        untildawn(robot, West)

        if !flag 
            break
        end
    
    end
    untildawn(robot, West)
    untildawn(robot, Sud)
    move!(robot, Nord, m)
    move!(robot, Ost, n)
    
    return k - 1
end
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 13
using HorizonSideRobots

include("functions.jl")
mutable struct ChessRobot
    robot::Robot
    flag::Bool
end
function HorizonSideRobots.move!(robot::ChessRobot, side)
    robot.flag && putmarker!(robot.robot)
    robot.flag  = !robot.flag
    move!(robot.robot, side)
end

function movetoend!(stop_condition::Function, robot, side)
    n=0
    while !stop_condition()
        move!(robot, side)
        n+=1
    end
    robot.flag && putmarker!(robot.robot)
    return n
end


function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s=sides[1]
    k = 0
    while !stop_condition(s)
        movetoend!(()->stop_condition(s) || isborder(robot.robot, s), robot,s)
        if stop_condition(s)
            break
        end
    s = inverse(s)
    move!(robot, sides[2])
    end
end

function chess(robot)
    k = untildawn(robot.robot, Nord)
    n = untildawn(robot.robot, West)
    move!(robot.robot, Sud, k)
    move!(robot.robot, Ost, n)
    if robot.flag == true
        putmarker!(robot.robot)
    end
    snake!( s -> isborder(robot.robot, Nord) && isborder(robot.robot, s), robot, (West, Nord))
    snake!( s -> isborder(robot.robot, Sud) && isborder(robot.robot, s), robot, (Ost, Sud))
    untildawn(robot.robot, Nord)
    untildawn(robot.robot, West)
    move!(robot.robot, Sud, k)
    move!(robot.robot, Ost, n)
end
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 14
using HorizonSideRobots


function trymove!(robot, side)
    
    if !isborder(robot.robot, side)
        move!(robot, side)
        return true
    end
    false
end

function HorizonSideRobots.move!(robot::ChessRobot, side::HorizonSide)

    robot.flag && putmarker!(robot.robot)
    move!(robot.robot, side)
    robot.flag = !robot.flag

end


function moves!(robot::ChessRobot, side::HorizonSide)
    k = 0
    while !isborder(robot.robot, side)
        move!(robot.robot, side)
        k += 1
    end
    return k
end



inverse(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)


function snake!(robot, x, next_row_side, move_side)
    
    while !isborder(robot.robot, next_row_side) || !isborder(robot.robot, move_side)
        x_count = 0
       

        while x_count<x
            y_count = 0
            while !isborder(robot.robot, move_side)
                move!(robot, move_side)
                x_count += 1
            end
            
            if x_count < x
                while isborder(robot.robot, move_side)
                    move!(robot, Sud)
                    y_count += 1
                end
                
                move!(robot, move_side)
                x_count += 1

                while isborder(robot.robot, Nord)
                    move!(robot, move_side)
                    x_count += 1
                end

                for _ in 1:y_count
                    move!(robot, Nord)
                end

            end
        end

        if trymove!(robot, next_row_side)
            move_side = inverse(move_side)
        end

    end

end



function movetoend!(robot)
    x0, y0 = 0, 0
    while !isborder(robot.robot, Sud) || !isborder(robot.robot, West)
        if !isborder(robot.robot, Sud)
            move!(robot, Sud)
            y0 += 1
        end
        if !isborder(robot.robot, West)
            move!(robot, West)
            x0 += 1
        end

    end 

    y = moves!(robot, Nord)
    x = moves!(robot, Ost)
    moves!(robot, Sud)
    moves!(robot, West)
    return x0, y0, x, y
end

function bord(robot)
    x, y = 0, 1
    while isborder(robot.robot, Nord)
        move!(robot.robot, West)
        x += 1
    end
    move!(robot.robot, Nord)
    while isborder(robot.robot, Ost)
        move!(robot.robot, Nord)
        y += 1
    end
    for _ in 1:x
        move!(robot.robot, Ost)
    end
    return y

end

function return!(robot, x0, y0)

    for _ in 1:x0
        move!(robot.robot, Ost)
    end

    while y0>0

        if !isborder(robot.robot, Nord)
            move!(robot.robot, Nord)
            y0 -= 1
        else
            k = bord(robot)
            y0 -= k
        end
    
    end

    
end
function chess!(robot)
    x0, y0, x, y = movetoend!(robot)
    snake!(robot, x, Nord, Ost)
    movetoend!(robot)
    return!(robot, x0, y0)
end
#////////////////////////////////////////////////////////////////////////////////////////////////////
#functions
using HorizonSideRobots
function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1 : num_steps
        move!(robot, side)
    end
end
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)
n = 0
function mark_direct!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n+=1
    end
    return n
end
function untildawn(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        k+=1
    end
    return k
end
function fillchamber(robot)
    for side in (Nord, Ost, Sud, West)
        if isborder(robot, side)
            putmarker!(robot)
        end
    end
end
