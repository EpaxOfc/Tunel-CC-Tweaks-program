os.loadAPI("tunnel_path.lua")
local pathAPI = tunnel_path
local modem = peripheral.find("modem") or error("Coloque um Modem!")
rednet.open(peripheral.getName(modem))

local myID = 1 -- Em um sistema real, o Master atribui esse ID
local totalTurtles = 1

local function buildBlock(b)
    -- Lógica de movimento e construção
    -- Vai até a coordenada b.x, b.y, b.z
    -- Quebra o bloco, coloca Stone Bricks se configurado
end

print("Aguardando comando do Master...")
local id, msg = rednet.receive("TUNNEL_SYNC")

if msg then
    print("Configuracao Recebida!")
    local centerLine = pathAPI.calculate(msg)
    local myWork = pathAPI.getBlocksForTurtle(myID, totalTurtles, centerLine, msg.width, msg.height)
    
    for _, block in ipairs(myWork) do
        -- A mágica acontece aqui:
        -- A turtle se move para block.x, block.y, block.z
        -- Como elas trabalham em colunas verticais, uma fica em cima da outra 
        -- ou ao lado, mas nunca cruzam o caminho horizontal.
    end
end
