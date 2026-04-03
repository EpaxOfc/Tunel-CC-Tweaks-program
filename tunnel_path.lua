local PathGen = {}

local function round(n) return math.floor(n + 0.5) end

-- Modo 1: Reta/Diagonal
function PathGen.calculateLinear(startPos, endPos)
    local points = {}
    local dx = endPos.x - startPos.x
    local dy = endPos.y - startPos.y
    local dz = endPos.z - startPos.z
    local steps = math.max(math.abs(dx), math.max(math.abs(dy), math.abs(dz)))

    for i = 0, steps do
        table.insert(points, {
            x = round(startPos.x + (dx * i / steps)),
            y = round(startPos.y + (dy * i / steps)),
            z = round(startPos.z + (dz * i / steps))
        })
    end
    return points
end

-- Modo 2: 90 Graus
function PathGen.calculate90Degree(startPos, endPos)
    local points = {}
    local pivot = {x = endPos.x, y = startPos.y, z = startPos.z}
    
    -- Trecho X
    local stepX = startPos.x < pivot.x and 1 or -1
    for x = startPos.x, pivot.x, stepX do
        table.insert(points, {x=x, y=startPos.y, z=startPos.z})
    end
    -- Trecho Z (com subida gradual de Y)
    local stepZ = startPos.z < endPos.z and 1 or -1
    local dz = math.abs(endPos.z - startPos.z)
    local dy = endPos.y - startPos.y
    
    for i = 1, dz do
        local currentZ = startPos.z + (i * stepZ)
        local currentY = round(startPos.y + (i / dz * dy))
        table.insert(points, {x=endPos.x, y=currentY, z=currentZ})
    end
    return points
end

-- Função que o Master e a Turtle chamam
function PathGen.calculate(config)
    if config.curveMode == "90" then
        return PathGen.calculate90Degree(config.startPos, config.endPos)
    else
        return PathGen.calculateLinear(config.startPos, config.endPos)
    end
end

-- Divisão de colunas verticais
function PathGen.getBlocksForTurtle(myID, total, centerLine, w, h)
    local myBlocks = {}
    local halfW = math.floor(w/2)
    for _, p in ipairs(centerLine) do
        for xOff = -halfW, halfW do
            -- Distribui colunas entre as turtles
            if (xOff + halfW) % total == (myID - 1) then
                for yOff = 0, h - 1 do
                    table.insert(myBlocks, {x=p.x, y=p.y + yOff, z=p.z, off=xOff})
                end
            end
        end
    end
    return myBlocks
end

return PathGen
