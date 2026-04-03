local PathGen = {}

-- Auxiliar: Arredondamento
local function round(n) return math.floor(n + 0.5) end

-- Calcula o caminho em Espiral (para grandes alturas)
function PathGen.calculateSpiral(startPos, endPos, radius)
    local points = {}
    local dy = endPos.y - startPos.y
    local heightAbs = math.abs(dy)
    local angleStep = 0.2 -- Suavidade da curva
    local currentY = startPos.y
    local angle = 0
    
    -- Precisamos de voltas suficientes para subir 1 por 1
    for h = 0, heightAbs do
        for a = 0, (math.pi * 2), angleStep do
            local x = round(startPos.x + math.cos(angle) * radius)
            local z = round(startPos.z + math.sin(angle) * radius)
            table.insert(points, {x=x, y=currentY, z=z})
            angle = angle + angleStep
        end
        currentY = currentY + (dy > 0 and 1 or -1)
    end
    return points
end

-- Calcula caminho com Curva de 90 graus (L-Shape)
function PathGen.calculate90Degree(startPos, endPos)
    local points = {}
    -- Ponto de Pivô (Esquina)
    local pivot = {x = endPos.x, y = startPos.y, z = startPos.z}
    
    -- Caminha no X
    local stepX = startPos.x < pivot.x and 1 or -1
    for x = startPos.x, pivot.x, stepX do
        table.insert(points, {x=x, y=startPos.y, z=startPos.z})
    end
    
    -- Caminha no Z (e gerencia o Y gradualmente aqui)
    local stepZ = pivot.z < endPos.z and 1 or -1
    local dy = endPos.y - startPos.y
    local totalStepsZ = math.abs(endPos.z - pivot.z)
    local currentStepZ = 0
    
    for z = pivot.z, endPos.z, stepZ do
        currentStepZ = currentStepZ + 1
        -- Calcula o Y para subir apenas 1 por 1
        local progressY = round((currentStepZ / totalStepsZ) * dy)
        table.insert(points, {x=pivot.x, y=startPos.y + progressY, z=z})
    end
    
    return points
end

function PathGen.calculate(config)
    local distH = math.sqrt((config.endPos.x - config.startPos.x)^2 + (config.endPos.z - config.startPos.z)^2)
    local distV = math.abs(config.endPos.y - config.startPos.y)

    -- Se a altura for muito grande para a distância, faz espiral
    if distV > distH then
        return PathGen.calculateSpiral(config.startPos, config.endPos, config.spiralRadius or 5)
    end

    -- Se o usuário quer 90 graus
    if config.curveMode == "90" then
        return PathGen.calculate90Degree(config.startPos, config.endPos)
    end

    -- Caso contrário, faz o linear simples (diagonal)
    -- (Mantido do código anterior para compatibilidade)
end

return PathGen