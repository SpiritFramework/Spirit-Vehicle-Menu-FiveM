-- ============================================
-- CUSTOM STYLED VEHICLE SPAWNER WITH NUI
-- Fully customizable position, colors, and branding
-- ============================================

local Display = false
local CurrentMenu = 'main'
local SelectedCategory = nil

-- ============================================
-- CONFIGURATION - EDIT THESE VALUES
-- ============================================

Config = {
    -- Server Branding
    ServerName = "SpiritHost Roleplay",
    ServerLogo = "https://iili.io/fZjwEG9.png",
    
    -- Menu Position (in percentage from top-left of screen)
    Position = {
        x = 95,
        y = 20
    },
    
    -- Menu Styling
    Style = {
        width = 350,
        maxHeight = 70,
        backgroundColor = "rgba(15, 15, 15, 0.95)",
        accentColor = "#ff6b6b",
        accentHover = "#ff8585",
        textColor = "#ffffff",
        subtextColor = "#b0b0b0",
        categoryColor = "#4ecdc4",
        font = "Rajdhani",
        borderRadius = "12px",
        itemHeight = "50px"
    },
    
    -- Animation Settings
    Animation = {
        enabled = true,
        openDuration = 300,
        hoverScale = 1.02
    }
}

-- Vehicle Database
Vehicles = {
    super = {
        label = "Super & Sports",
        icon = "🏎️",
        color = "#ff6b6b",
        vehicles = {
            { name = "adder", label = "Adder", desc = "High-speed hypercar" },
            { name = "entityxf", label = "Entity XF", desc = "Ultimate performance" },
            { name = "fmj", label = "FMJ", desc = "Aerodynamic beast" },
            { name = "cheetah", label = "Cheetah", desc = "Classic supercar" },
            { name = "infernus", label = "Infernus", desc = "Italian excellence" },
            { name = "vacca", label = "Vacca", desc = "Compact power" },
            { name = "zentorno", label = "Zentorno", desc = "Aggressive styling" },
            { name = "turismor", label = "Turismo R", desc = "Track ready" },
            { name = "t20", label = "T20", desc = "Active aero" },
            { name = "reaper", label = "Reaper", desc = "Street predator" },
            { name = "pfister811", label = "811", desc = "Electric hybrid" },
            { name = "tyrus", label = "Tyrus", desc = "Race heritage" },
            { name = "sultanrs", label = "Sultan RS", desc = "Tuner icon" },
            { name = "banshee2", label = "Banshee 900R", desc = "American muscle" },
        }
    },
    
    muscle = {
        label = "Muscle & Classic",
        icon = "💪",
        color = "#ffa502",
        vehicles = {
            { name = "dominator", label = "Dominator", desc = "Modern muscle" },
            { name = "gauntlet", label = "Gauntlet", desc = "Brute force" },
            { name = "sabregt", label = "Sabre GT", desc = "Retro cool" },
            { name = "tornado", label = "Tornado", desc = "Lowrider style" },
            { name = "buccaneer", label = "Buccaneer", desc = "Pirate ship" },
            { name = "vigero", label = "Vigero", desc = "Raw power" },
            { name = "dukes", label = "Dukes", desc = "General Lee vibes" },
            { name = "faction", label = "Faction", desc = "Custom king" },
            { name = "moonbeam", label = "Moonbeam", desc = "Van life" },
            { name = "chino", label = "Chino", desc = "Low and slow" },
            { name = "hotknife", label = "Hotknife", desc = "Hot rod" },
            { name = "coquette3", label = "Coquette BlackFin", desc = "Vintage race" },
        }
    },
    
    luxury = {
        label = "Luxury & Sedans",
        icon = "✨",
        color = "#2ed573",
        vehicles = {
            { name = "cognoscenti", label = "Cognoscenti", desc = "Executive class" },
            { name = "cog55", label = "Cognoscenti 55", desc = "Armored luxury" },
            { name = "schafter2", label = "Schafter", desc = "Business cruiser" },
        }
    },
    
    offroad = {
        label = "Off-Road & SUVs",
        icon = "🏔️",
        color = "#8b5cf6",
        vehicles = {
            { name = "sanchez", label = "Sanchez", desc = "Dirt bike legend" },
            { name = "bf400", label = "BF400", desc = "Lightweight enduro" },
        }
    },
    
    motorcycles = {
        label = "Motorcycles",
        icon = "🏍️",
        color = "#ff4757",
        vehicles = {
            { name = "akuma", label = "Akuma", desc = "Naked aggression" },
            { name = "bati", label = "Bati 801", desc = "Italian superbike" },
        }
    },
    
    emergency = {
        label = "Emergency",
        icon = "🚨",
        color = "#1e90ff",
        vehicles = {
            { name = "police", label = "Police Cruiser", desc = "Stanier patrol" },
        }
    },
    
    helicopters = {
        label = "Helicopters",
        icon = "🚁",
        color = "#00d2d3",
        vehicles = {
            { name = "buzzard", label = "Buzzard", desc = "Light attack" },
        }
    },
    
    planes = {
        label = "Planes",
        icon = "✈️",
        color = "#5f27cd",
        vehicles = {
            { name = "besra", label = "Besra", desc = "Military jet trainer" },
        }
    },
    
    boats = {
        label = "Boats",
        icon = "🚤",
        color = "#00d8d6",
        vehicles = {
            { name = "dinghy", label = "Dinghy", desc = "Rubber boat" },
        }
    },
    
    utility = {
        label = "Commercial",
        icon = "🚚",
        color = "#ff9f43",
        vehicles = {
            { name = "phantom", label = "Phantom", desc = "Semi truck" },
            { name = "hauler", label = "Hauler", desc = "Day cab" },
            { name = "packer", label = "Packer", desc = "Car carrier" },
        }
    },
    
    bicycles = {
        label = "Bicycles",
        icon = "🚲",
        color = "#10ac84",
        vehicles = {
            { name = "bmx", label = "BMX", desc = "Trick bike" },
            { name = "cruiser", label = "Cruiser", desc = "Beach ride" },
        }
    }
}

-- ============================================
-- NUI FUNCTIONS
-- ============================================

function ToggleMenu(show, menuType, data)
    Display = show
    CurrentMenu = menuType or 'main'
    
    SetNuiFocus(show, show)
    
    SendNUIMessage({
        type = "toggle",
        display = show,
        menu = CurrentMenu,
        config = Config,
        data = data or GetMainMenuData()
    })
end

function GetMainMenuData()
    local categories = {}
    for key, category in pairs(Vehicles) do
        table.insert(categories, {
            key = key,
            label = category.label,
            icon = category.icon,
            color = category.color,
            count = #category.vehicles
        })
    end
    
    table.sort(categories, function(a, b) return a.label < b.label end)
    
    return {
        categories = categories,
        serverName = Config.ServerName,
        currentPath = "Main Menu"
    }
end

function GetCategoryData(categoryKey)
    local category = Vehicles[categoryKey]
    if not category then return nil end
    
    return {
        vehicles = category.vehicles,
        categoryName = category.label,
        categoryIcon = category.icon,
        categoryColor = category.color,
        serverName = Config.ServerName,
        currentPath = category.label
    }
end

-- ============================================
-- SPAWN FUNCTION
-- ============================================

function SpawnVehicle(modelName, vehicleLabel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local spawnPos = vector3(coords.x + forward.x * 3.0, coords.y + forward.y * 3.0, coords.z)
    
    local model = GetHashKey(modelName)
    RequestModel(model)
    
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 5000 do
        Wait(10)
        timeout = timeout + 10
    end
    
    if not HasModelLoaded(model) then
        TriggerEvent('notifications:show', 'error', 'Failed to load vehicle model!', 5000)
        return
    end
    
    if IsPedInAnyVehicle(playerPed, false) then
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        SetEntityAsMissionEntity(currentVehicle, true, true)
        DeleteVehicle(currentVehicle)
        Wait(200)
    end
    
    local _, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z, 0)
    if groundZ == 0 then groundZ = spawnPos.z end
    
    local heading = GetEntityHeading(playerPed)
    local vehicle = CreateVehicle(model, spawnPos.x, spawnPos.y, groundZ + 0.5, heading, true, false)
    
    if vehicle and vehicle ~= 0 then
        SetPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, string.sub(Config.ServerName:gsub("%s+", ""), 1, 8):upper())
        SetVehicleModKit(vehicle, 0)
        SetVehicleWindowTint(vehicle, 1)
        
        if not string.find(modelName, "police") and not string.find(modelName, "sheriff") then
            local r, g, b = math.random(50, 255), math.random(50, 255), math.random(50, 255)
            SetVehicleCustomPrimaryColour(vehicle, r, g, b)
        end
        
        SetEntityAsNoLongerNeeded(vehicle)
        ToggleMenu(false)
        
        TriggerEvent('notifications:show', 'success', 'Spawned: ' .. vehicleLabel, 5000)
    else
        TriggerEvent('notifications:show', 'error', 'Failed to spawn vehicle!', 5000)
    end
    
    SetModelAsNoLongerNeeded(model)
end

-- ============================================
-- NUI CALLBACKS
-- ============================================

RegisterNUICallback('close', function(data, cb)
    ToggleMenu(false)
    cb('ok')
end)

RegisterNUICallback('selectCategory', function(data, cb)
    local categoryData = GetCategoryData(data.category)
    SendNUIMessage({
        type = "updateMenu",
        menu = "category",
        data = categoryData
    })
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    SpawnVehicle(data.model, data.label)
    cb('ok')
end)

RegisterNUICallback('goBack', function(data, cb)
    SendNUIMessage({
        type = "updateMenu",
        menu = "main",
        data = GetMainMenuData()
    })
    cb('ok')
end)

-- ============================================
-- COMMANDS
-- ============================================

RegisterCommand('car', function()
    ToggleMenu(true, 'main')
end, false)

RegisterCommand('vehicle', function()
    ToggleMenu(true, 'main')
end, false)

RegisterCommand('vspawn', function(source, args)
    if args[1] then
        SpawnVehicle(args[1], args[1])
    else
        ToggleMenu(true, 'main')
    end
end, false)

-- ============================================
-- KEYBINDS
-- ============================================

RegisterKeyMapping('car', 'Toggle Vehicle Menu', 'keyboard', 'F5')

-- Utility commands
RegisterCommand('dv', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        TriggerEvent('notifications:show', 'info', 'Vehicle Deleted', 4000)
    else
        TriggerEvent('notifications:show', 'error', 'You are not in a vehicle!', 4000)
    end
end, false)

RegisterCommand('fix', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, false)
        TriggerEvent('notifications:show', 'success', 'Vehicle Repaired', 4000)
    else
        TriggerEvent('notifications:show', 'error', 'You are not in a vehicle!', 4000)
    end
end, false)

-- ============================================
-- RESOURCE START/STOP
-- ============================================

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print('[^2Vehicle Spawner^7] Loaded - Server: ' .. Config.ServerName)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if Display then
        SetNuiFocus(false, false)
    end
end)