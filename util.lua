-- Returns smallest number
function Min(a, b)
    if a < b then
        return a
    else
        return b
    end
end

-- Returns largest number
function Max(a, b)
    if a < b then
        return b
    else
        return a
    end
end

-- Clamps value between two bounds
function ClampBetween(a, min, max)
    return Min(Max(a, min), max)
end

--[[
    Checks collision between two obj
    obj = [x,y,width,height]
        -> Where x,y is the center
]] 
function CheckCollision(obj1, obj2)
    -- Calc edges
    A_X1 = obj1[1] - (obj1[3] / 2)
    A_X2 = obj1[1] + (obj1[3] / 2)
    A_Y1 = obj1[2] - (obj1[4] / 2)
    A_Y2 = obj1[2] + (obj1[4] / 2)
    B_X1 = obj2[1] - (obj2[3] / 2)
    B_X2 = obj2[1] + (obj2[3] / 2)
    B_Y1 = obj2[2] - (obj2[4] / 2)
    B_Y2 = obj2[2] + (obj2[4] / 2)

    -- Math
    return A_X1 < B_X2 and A_X2 > B_X1 and A_Y1 < B_Y2 and A_Y2 > B_Y1
end

--[[
    Linearly interpolates between two values
    Tried to research the math behind this to recreate
    the unity function Mathf.Lerp().

    The wikipedia page on linear interpolation legit
    had code snippets at the bottom so that saved me
    some time :)
]]
function lerp(v0, v1, t) 
    return (1 - t) * v0 + t * v1;
end

--[[
    Switch statement implementation
    https://gist.github.com/FreeBirdLjj/6303864
]]
_G.switch = function(param, case_table)
    local case = case_table[param]
    if case then return case() end
    local def = case_table['default']
    return def and def() or nil
end