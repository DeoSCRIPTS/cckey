--[[

██████╗  █████╗ ███╗   ██╗██╗    ██╗ █████╗ ██████╗ ███████╗
██╔══██╗██╔══██╗████╗  ██║██║    ██║██╔══██╗██╔══██╗██╔════╝
██████╔╝███████║██╔██╗ ██║██║ █╗ ██║███████║██████╔╝█████╗
██╔══██╗██╔══██║██║╚██╗██║██║███╗██║██╔══██║██╔══██╗██╔══╝
██████╔╝██║  ██║██║ ╚████║╚███╔███╔╝██║  ██║██║  ██║███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

    > best hvh lua out there
    > banware framework
    > build 14 / v1.4.7
    > created by bananalyze (check him out on discord!)

]]

--//====================================================--
--//                    CONFIGURATION                  --
--//====================================================--

getgenv().banware = getgenv().banware or {
    key = "banware_EVcYLFxkmfMshdKJ",
    author = "bananalyze",
    build_number = 14,
    resolver = "adaptive", -- adaptive / offense / defense
    qot = false
}

--//====================================================--
--//                INITIATE CONFIGURATIONS            --
--//====================================================--

local cfg = getgenv().banware

--//====================================================--
--//                      SERVICES                      --
--//====================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--//====================================================--
--//                     CONSTANTS                     --
--//====================================================--

local CURRENT_VERSION = "v1.4.7"

local VERSION_URL = "https://raw.githubusercontent.com/DeoSCRIPTS/cckey/refs/heads/main/version2.txt"
local KEYS_URL    = "https://raw.githubusercontent.com/DeoSCRIPTS/cckey/refs/heads/main/keys.json"
local SCRIPT_URL  = "https://raw.githubusercontent.com/DeoSCRIPTS/cckey/refs/heads/main/voidspam.lua"

local VALID_RESOLVERS = {
    adaptive = true,
    offense = true,
    defense = true
}

--//====================================================--
--//                     CLEANUP                       --
--//====================================================--

if getgenv().banware_connections then
    for _, connection in pairs(getgenv().banware_connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
end

pcall(function()
    RunService:UnbindFromRenderStep("csync")
end)

getgenv().banware_connections = {}

local connections = getgenv().banware_connections

--//====================================================--
--//                     FUNCTIONS                     --
--//====================================================--

local function terminate(reason)
    LocalPlayer:Kick("[ banware ] " .. tostring(reason))
    error(reason, 0)
end

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function betterRandom(minimum, maximum, deadzoneMin, deadzoneMax)
    local value

    repeat
        value = math.random(minimum, maximum)
    until value < deadzoneMin or value > deadzoneMax

    return value
end

--//====================================================--
--//                    VALIDATION                     --
--//====================================================--

if not cfg then
    terminate("configuration missing")
end

if cfg.author ~= "bananalyze" then
    terminate("watermark integrity check failed")
end

if tonumber(cfg.build_number) ~= 14 then
    terminate("invalid build number")
end

if not VALID_RESOLVERS[string.lower(tostring(cfg.resolver))] then
    terminate("invalid resolver mode")
end

--//====================================================--
--//                  VERSION CHECK                    --
--//====================================================--

local versionSuccess, latestVersion = pcall(function()
    return game:HttpGet(VERSION_URL)
end)

if versionSuccess then
    latestVersion = tostring(latestVersion):gsub("%s+", "")

    if latestVersion ~= CURRENT_VERSION then
        terminate(
            "outdated version\n" ..
            "current: " .. CURRENT_VERSION .. "\n" ..
            "latest: " .. latestVersion
        )
    end
else
    warn("[ banware ] failed to contact version server")
end

--//====================================================--
--//                 KEY AUTHENTICATION                --
--//====================================================--

local keySuccess, response = pcall(function()
    return game:HttpGet(KEYS_URL)
end)

if not keySuccess then
    terminate("failed to contact key server")
end

local decoded

local decodeSuccess = pcall(function()
    decoded = HttpService:JSONDecode(response)
end)

if not decodeSuccess then
    terminate("invalid key database")
end

local validKey = false

for _, key in ipairs(decoded) do
    if tostring(key) == tostring(cfg.key) then
        validKey = true
        break
    end
end

if not validKey then
    terminate("invalid key")
end

--//====================================================--
--//                QUEUE ON TELEPORT                  --
--//====================================================--

local qot =
    queue_on_teleport
    or queueonteleport
    or (syn and syn.queue_on_teleport)

if cfg.qot == true and qot then
    qot(string.format([[
        getgenv().banware = {
            key = "%s",
            author = "bananalyze",
            build_number = 14,
            resolver = "%s",
            qot = true,
        }

        loadstring(game:HttpGet("%s"))()
    ]],
        tostring(cfg.key),
        tostring(cfg.resolver),
        SCRIPT_URL
    ))
end

--//====================================================--
--//                     STARTUP                       --
--//====================================================--

task.wait(0.15)

print([[

██████╗  █████╗ ███╗   ██╗██╗    ██╗ █████╗ ██████╗ ███████╗
██╔══██╗██╔══██╗████╗  ██║██║    ██║██╔══██╗██╔══██╗██╔════╝
██████╔╝███████║██╔██╗ ██║██║ █╗ ██║███████║██████╔╝█████╗
██╔══██╗██╔══██║██║╚██╗██║██║███╗██║██╔══██║██╔══██╗██╔══╝
██████╔╝██║  ██║██║ ╚████║╚███╔███╔╝██║  ██║██║  ██║███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

]])

print(string.format(
    "[ banware ] initialized successfully\n" ..
    "[ build     ] #%s\n" ..
    "[ version   ] %s\n" ..
    "[ resolver  ] %s\n" ..
    "[ qot       ] %s\n" ..
    "[ author    ] %s\n",
    tostring(cfg.build_number),
    CURRENT_VERSION,
    tostring(cfg.resolver),
    tostring(cfg.qot),
    tostring(cfg.author)
))

print("[ auth      ] key authenticated successfully")
print("[ controls  ] PRESS P TO TOGGLE")
print("[ community ] .gg/luas")

--//====================================================--
--//                     VOID SPAM                     --
--//====================================================--

local enabled = false

local clientc
local clientv
local clientva
local hrp

connect(UserInputService.InputBegan, function(input, gp)
    if gp then
        return
    end

    if input.KeyCode == Enum.KeyCode.P then
        enabled = not enabled
        print("[ banware ] Status: " .. (enabled and "ON" or "OFF"))
    end
end)

connect(RunService.Heartbeat, function()
    if not enabled then
        return
    end

    pcall(function()
        local character = LocalPlayer.Character

        if not character then
            return
        end

        hrp = character:FindFirstChild("HumanoidRootPart")

        if not hrp then
            return
        end

        clientc = hrp.CFrame
        clientv = hrp.AssemblyLinearVelocity
        clientva = hrp.AssemblyAngularVelocity

        hrp.CFrame = CFrame.new(
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646),
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646),
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646)
        ) * CFrame.Angles(
            math.rad(180),
            math.rad(180),
            math.rad(180)
        )

        hrp.AssemblyLinearVelocity = Vector3.new(
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646),
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646),
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646)
        )

        hrp.AssemblyAngularVelocity = Vector3.new(
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646),
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646),
            betterRandom(-2147483646, 2147483646, -1147483646, 1147483646)
        )
    end)
end)

RunService:BindToRenderStep("csync", Enum.RenderPriority.First.Value, function()
    if not enabled then
        return
    end

    if hrp then
        pcall(function()
            hrp.CFrame = clientc
            hrp.AssemblyLinearVelocity = clientv
            hrp.AssemblyAngularVelocity = clientva
        end)
    end
end)
