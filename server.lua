-- ============================================
-- SERVER-SIDE VERSION CHECKER
-- ============================================

local RESOURCE_NAME = GetCurrentResourceName()
local CURRENT_VERSION = GetResourceMetadata(RESOURCE_NAME, 'version', 0) or '1.0.0'

-- Your GitHub raw version URL (update with your actual repo)
local GITHUB_VERSION_URL = 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/version.txt'
local GITHUB_DOWNLOAD_URL = 'https://github.com/YOUR_USERNAME/YOUR_REPO/releases'

-- Check interval (24 hours in ms)
local CHECK_INTERVAL = 24 * 60 * 60 * 1000

local lastCheck = 0
local updateAvailable = false
local latestVersion = CURRENT_VERSION

-- ============================================
-- VERSION CHECK FUNCTIONS
-- ============================================

function PerformVersionCheck()
    print('[^2' .. RESOURCE_NAME .. '^7] Checking for updates...')
    
    PerformHttpRequest(GITHUB_VERSION_URL, function(statusCode, response, headers)
        if statusCode ~= 200 or not response then
            print('[^1' .. RESOURCE_NAME .. '^7] Failed to check version (HTTP ' .. statusCode .. ')')
            return
        end
        
        -- Clean up response (remove whitespace/newlines)
        latestVersion = response:gsub("%s+", "")
        
        -- Compare versions
        if IsNewerVersion(latestVersion, CURRENT_VERSION) then
            updateAvailable = true
            print('[^3' .. RESOURCE_NAME .. '^7] ^1UPDATE AVAILABLE^7')
            print('[^3' .. RESOURCE_NAME .. '^7] Current: ^1' .. CURRENT_VERSION .. '^7')
            print('[^3' .. RESOURCE_NAME .. '^7] Latest: ^2' .. latestVersion .. '^7')
            print('[^3' .. RESOURCE_NAME .. '^7] Download: ^5' .. GITHUB_DOWNLOAD_URL .. '^7')
            
            -- Notify players with permission (optional)
            NotifyAdmins('Update available for ' .. RESOURCE_NAME .. ': ' .. CURRENT_VERSION .. ' -> ' .. latestVersion)
        else
            print('[^2' .. RESOURCE_NAME .. '^7] Up to date! (v' .. CURRENT_VERSION .. ')')
        end
        
        lastCheck = GetGameTimer()
    end, 'GET', '', {})
end

function IsNewerVersion(latest, current)
    -- Remove 'v' prefix if present
    latest = latest:gsub("^v", "")
    current = current:gsub("^v", "")
    
    local latestParts = {}
    local currentParts = {}
    
    -- Split version numbers
    for num in latest:gmatch("%d+") do
        table.insert(latestParts, tonumber(num))
    end
    
    for num in current:gmatch("%d+") do
        table.insert(currentParts, tonumber(num))
    end
    
    -- Compare each part
    for i = 1, math.max(#latestParts, #currentParts) do
        local latestPart = latestParts[i] or 0
        local currentPart = currentParts[i] or 0
        
        if latestPart > currentPart then
            return true
        elseif latestPart < currentPart then
            return false
        end
    end
    
    return false
end

function NotifyAdmins(message)
    -- Optional: Notify admins in-game about update
    -- Requires your notification system on client
    --[[
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        -- Check if player has admin permission
        -- if IsPlayerAdmin(playerId) then
        TriggerClientEvent('notifications:show', playerId, 'info', message, 10000)
        -- end
    end
    --]]
end

-- ============================================
-- COMMANDS
-- ============================================

RegisterCommand('vcheck', function(source, args, rawCommand)
    if source ~= 0 then
        -- Player executed command - check permissions if needed
        -- if not IsPlayerAdmin(source) then return end
    end
    
    print('[^2' .. RESOURCE_NAME .. '^7] Manually checking for updates...')
    PerformVersionCheck()
end, true) -- true = restricted to RCON/console only (change to false for all players)

RegisterCommand('vversion', function(source, args, rawCommand)
    local message = RESOURCE_NAME .. ' | Current: ' .. CURRENT_VERSION .. ' | Latest: ' .. latestVersion
    
    if source == 0 then
        -- Console
        print('[^2' .. RESOURCE_NAME .. '^7] ' .. message)
    else
        -- In-game player
        TriggerClientEvent('notifications:show', source, 'info', message, 5000)
    end
end, false)

-- ============================================
-- EVENTS
-- ============================================

RegisterServerEvent(RESOURCE_NAME .. ':requestVersion')
AddEventHandler(RESOURCE_NAME .. ':requestVersion', function()
    local src = source
    TriggerClientEvent(RESOURCE_NAME .. ':receiveVersion', src, {
        current = CURRENT_VERSION,
        latest = latestVersion,
        updateAvailable = updateAvailable,
        downloadUrl = GITHUB_DOWNLOAD_URL
    })
end)

-- ============================================
-- INITIALIZATION
-- ============================================

CreateThread(function()
    Wait(5000) -- Wait 5 seconds after resource start
    PerformVersionCheck()
    
    -- Periodic checks
    while true do
        Wait(CHECK_INTERVAL)
        PerformVersionCheck()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= RESOURCE_NAME then return end
    print('[^2' .. RESOURCE_NAME .. '^7] Server-side loaded | Version: ' .. CURRENT_VERSION)
end)