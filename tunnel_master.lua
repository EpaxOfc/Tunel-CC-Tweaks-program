local pathAPI = require("tunnel_path")
local modem = peripheral.find("modem") or error("Precisa de um Modem!")
rednet.open(peripheral.getName(modem))

local config = {
    startPos = {x=0, y=64, z=0},
    endPos = {x=50, y=64, z=50},
    width = 3, height = 3, mode = 1, monitorSide = "top"
    print("Escolha o tipo de curva:")
    print("1. Diagonal (Reta)")
    print("2. 90 Graus (L-Shape)")
    local c = read()
    config.curveMode = (c == "2") and "90" or "linear"

    if distV > distH then
        print("Detectada subida ingrime! Definir raio da espiral (padrao 5):")
        config.spiralRadius = tonumber(read()) or 5
    end
}

local function drawGUI()
    local mon = peripheral.wrap(config.monitorSide)
    if not mon then return end
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setCursorPos(1,1)
    mon.setTextColor(colors.yellow)
    mon.write("--- TUNNEL MASTER SERVER ---")
    mon.setCursorPos(1,3)
    mon.setTextColor(colors.white)
    mon.write("Status: AGUARDANDO TURTLES")
    -- Aqui você pode adicionar o desenho do mapa baseado no pathAPI.calculate
end

local function broadcastConfig()
    print("Enviando configuracao para todas as Turtles...")
    rednet.broadcast(config, "TUNNEL_SYNC")
end

while true do
    term.clear()
    print("1. Configurar Posicoes")
    print("2. Iniciar Construcao")
    print("3. Abrir Monitor")
    local input = read()
    
    if input == "1" then
        -- Lógica de perguntar coordenadas...
    elseif input == "2" then
        broadcastConfig()
    elseif input == "3" then
        drawGUI()
    end
end