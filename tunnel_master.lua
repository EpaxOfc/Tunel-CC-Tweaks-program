local pathAPI = require("tunnel_path")
local modem = peripheral.find("modem") or error("Precisa de um Modem Wireless!")
rednet.open(peripheral.getName(modem))

-- Configurações padrão
local config = {
    startPos = {x=0, y=64, z=0},
    endPos = {x=50, y=64, z=50},
    width = 3,
    height = 3,
    mode = 1,
    monitorSide = "top",
    curveMode = "linear",
    spiralRadius = 5
}

local function drawGUI()
    local mon = peripheral.wrap(config.monitorSide)
    if not mon then 
        print("Aviso: Monitor nao encontrado no lado: "..config.monitorSide)
        return 
    end
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setCursorPos(1,1)
    mon.setTextColor(colors.yellow)
    mon.write("--- TUNNEL MASTER SERVER ---")
    mon.setCursorPos(1,3)
    mon.setTextColor(colors.white)
    mon.write("Status: AGUARDANDO TURTLES")
    mon.setCursorPos(1,5)
    mon.write("Inicio: "..config.startPos.x..","..config.startPos.z)
    mon.setCursorPos(1,6)
    mon.write("Final:  "..config.endPos.x..","..config.endPos.z)
end

local function configureSystem()
    term.clear()
    term.setCursorPos(1,1)
    print("=== CONFIGURACAO DO TUNEL ===")
    
    print("\nPosicao INICIAL:")
    write("X: ") config.startPos.x = tonumber(read())
    write("Y: ") config.startPos.y = tonumber(read())
    write("Z: ") config.startPos.z = tonumber(read())
    
    print("\nPosicao FINAL:")
    write("X: ") config.endPos.x = tonumber(read())
    write("Y: ") config.endPos.y = tonumber(read())
    write("Z: ") config.endPos.z = tonumber(read())
    
    print("\nTamanho (Largura x Altura):")
    write("Largura: ") config.width = tonumber(read())
    write("Altura: ") config.height = tonumber(read())
    
    print("\nTipo de curva:")
    print("1. Diagonal (Reta)")
    print("2. 90 Graus (L-Shape)")
    local c = read()
    config.curveMode = (c == "2") and "90" or "linear"
    
    local distH = math.sqrt((config.endPos.x - config.startPos.x)^2 + (config.endPos.z - config.startPos.z)^2)
    local distV = math.abs(config.endPos.y - config.startPos.y)
    
    if distV > distH then
        print("\nSubida ingrime detectada!")
        write("Definir raio da espiral (padrao 5): ")
        config.spiralRadius = tonumber(read()) or 5
    end
    
    print("\nLado do Monitor (top, bottom, left, etc):")
    config.monitorSide = read()
    
    print("\nConfiguracao salva! Pressione Enter.")
    read()
end

local function broadcastConfig()
    term.clear()
    term.setCursorPos(1,1)
    print("Transmitindo configuracao via Rednet...")
    rednet.broadcast(config, "TUNNEL_SYNC")
    sleep(2)
    print("Sinal enviado! Verifique as Turtles.")
    sleep(2)
end

-- LOOP PRINCIPAL DO MENU
while true do
    term.clear()
    term.setCursorPos(1,1)
    print("=== TUNNEL MASTER V2 ===")
    print("1. Configurar Posicoes")
    print("2. Iniciar Construcao (Broadcast)")
    print("3. Abrir Monitor")
    print("0. Sair")
    write("\nEscolha: ")
    local input = read()
    
    if input == "1" then
        configureSystem()
    elseif input == "2" then
        broadcastConfig()
    elseif input == "3" then
        drawGUI()
        print("\nMonitor ligado. Pressione Enter para voltar ao menu.")
        read()
    elseif input == "0" then
        break
    end
end
