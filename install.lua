local USER = "SeuUsuario" -- Mude para o seu user do GitHub
local REPO = "SeuRepositorio" -- Mude para o nome do repo
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/"..USER.."/"..REPO.."/"..BRANCH.."/"

local files = {
    shared = {"tunnel_path.lua"},
    computer = {"tunnel_master.lua"},
    turtle = {"tunnel_turtle.lua"}
}

print("=== TUNNEL MASTER INSTALLER ===")

local function download(name)
    print("Baixando: " .. name)
    local res = http.get(BASE_URL .. name)
    if res then
        local f = fs.open(name, "w")
        f.write(res.readAll())
        f.close()
        return true
    end
    return false
end

-- Baixa arquivos compartilhados
for _, f in ipairs(files.shared) do download(f) end

if turtle then
    for _, f in ipairs(files.turtle) do download(f) end
    shell.run("mv tunnel_turtle.lua startup.lua")
    print("\nInstalado na Turtle! Reiniciando...")
else
    for _, f in ipairs(files.computer) do download(f) end
    shell.run("mv tunnel_master.lua startup.lua")
    print("\nInstalado no PC! Reiniciando...")
end
os.reboot()