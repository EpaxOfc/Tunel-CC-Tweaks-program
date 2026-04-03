local pathAPI = require("tunnel_path")
local modem = peripheral.find("modem") or error("Sem Modem!")
rednet.open(peripheral.getName(modem))

local function goTo(target)
    local x, y, z = gps.locate()
    if not x then return false end
    -- Lógica simples de movimento (subir/descer e andar)
    while y < target.y do turtle.up() y = y + 1 end
    while y > target.y do turtle.down() y = y - 1 end
    -- Aqui você deve adicionar a lógica de girar e ir para X e Z
    -- Para fins de teste, ela vai apenas cavar o que estiver na frente
    if turtle.detect() then turtle.dig() end
    return true
end

print("Aguardando comando do Master...")
local id, msg = rednet.receive("TUNNEL_SYNC")

if msg then
    print("Configuracao Recebida!")
    -- Agora o calculate vai existir!
    local centerLine = pathAPI.calculate(msg)
    local myWork = pathAPI.getBlocksForTurtle(1, 1, centerLine, msg.width, msg.height)
    
    print("Trabalho gerado: "..#myWork.." blocos.")
    for _, block in ipairs(myWork) do
        -- A turtle executa o bloco aqui
        -- Exemplo: goTo(block)
    end
    print("Trabalho concluido!")
end
