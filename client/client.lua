local Core = exports.vorp_core:GetCore()
local progressbar = exports.vorp_progressbar:initiate()

local rn = GetCurrentResourceName()
if rn ~= "PyThor_Gunpowder-Check" then
    print("Please rename the resource to the original name")
    StopResource(GetCurrentResourceName())
end

-- events
RegisterNetEvent("GP:CheckJob")
RegisterNetEvent("GP:CheckJobResult")
RegisterNetEvent("GP:SetGunpowderServer")
RegisterNetEvent("GP:CheckGunpowderServer")
RegisterNetEvent("GP:CheckGunpowderResult")

-- Decorators
DecorRegister("HasShot", 2)
DecorRegister("GunpowderWeapon", 3)
DecorRegister("WashesRequired", 2)
DecorRegister("WashesDone", 2)

function Dev(...)
    if Config.DevMode then
        print(...)
    end
end

-- global vars
local IsLaw = false
local command = Config.Command

local animDict = "script_amb@stores@store_waist_stern_guy"
local animName = "base"
RequestAnimDict(animDict)
while not HasAnimDictLoaded(animDict) do Citizen.Wait(100) end

-- EXPORTS
-- Check if a player has gunpowder residue
exports('HasGunpowderResidue', function(target)
    if not target then
        target = PlayerPedId()
    end
    
    if DecorExistOn(target, "HasShot") then
        return DecorGetBool(target, "HasShot")
    end
    return false
end)

-- Get weapon hash that caused the residue
exports('GetResidueWeapon', function(target)
    if not target then
        target = PlayerPedId()
    end
    
    if DecorExistOn(target, "GunpowderWeapon") then
        return DecorGetInt(target, "GunpowderWeapon")
    end
    return 0
end)

-- Get washes done and required
exports('GetWashesInfo', function(target)
    if not target then
        target = PlayerPedId()
    end
    
    local info = {
        done = 0,
        required = Config.WashesToClean
    }
    
    if DecorExistOn(target, "WashesDone") then
        info.done = DecorGetInt(target, "WashesDone")
    end
    
    if DecorExistOn(target, "WashesRequired") then
        info.required = DecorGetInt(target, "WashesRequired")
    end
    
    return info
end)

-- Manually set gunpowder residue on a player
exports('SetGunpowderResidue', function(state, weaponHash, target)
    if not target then
        target = PlayerPedId()
    end
    
    if state then
        -- Set gunpowder residue
        DecorSetBool(target, "HasShot", true)
        
        -- Set weapon type for expiration time
        if weaponHash then
            DecorSetInt(target, "GunpowderWeapon", weaponHash)
            
            -- Set required washes based on weapon
            local washesRequired = Config.WashesToClean
            if Config.WeaponWashRequirements[weaponHash] then
                washesRequired = Config.WeaponWashRequirements[weaponHash]
            end
            DecorSetInt(target, "WashesRequired", washesRequired)
            DecorSetInt(target, "WashesDone", 0)
        else
            DecorSetInt(target, "WashesRequired", Config.WashesToClean)
            DecorSetInt(target, "WashesDone", 0)
        end
        
        -- Start expiration timer
        local expirationTime = Config.DefaultTimeToExpire
        if weaponHash and Config.WeaponExpireTimes[weaponHash] then
            expirationTime = Config.WeaponExpireTimes[weaponHash]
        end
        
        -- Trigger the expiration timer logic
        Citizen.CreateThread(function()
            local timeLeft = expirationTime
            
            while timeLeft > 0 and DecorGetBool(target, "HasShot") do
                Wait(1000)
                timeLeft = timeLeft - 1000
                
                -- Check if player is in water (for wash logic)
                if IsEntityInWater(target) then
                    local currentWashes = DecorGetInt(target, "WashesDone")
                    local requiredWashes = DecorGetInt(target, "WashesRequired")
                    
                    -- Increment wash counter and check if clean
                    currentWashes = currentWashes + 1
                    DecorSetInt(target, "WashesDone", currentWashes)
                    
                    if currentWashes >= requiredWashes then
                        Dev("Player has washed enough times, removing gunpowder")
                        DecorSetBool(target, "HasShot", false)
                        Core.NotifyRightTip("Você está limpo agora.", 4000)
                        break
                    else
                        Core.NotifyRightTip("Você precisa se lavar mais " .. (requiredWashes - currentWashes) .. " vezes.", 4000)
                        
                        -- Wait some time before allowing another wash
                        Wait(5000)
                    end
                end
                
                Dev("Time left: " .. timeLeft / 1000)
            end
            
            -- If time expired naturally
            if timeLeft <= 0 and DecorGetBool(target, "HasShot") then
                Dev("Time expired, resetting HasShot")
                DecorSetBool(target, "HasShot", false)
                Core.NotifyRightTip("Você está limpo agora.", 4000)
            end
        end)
        
        return true
    else
        -- Clear gunpowder residue
        DecorSetBool(target, "HasShot", false)
        return true
    end
    
    return false
end)

-- Get remaining time for gunpowder residue - placeholder function
exports('GetGunpowderTimeLeft', function(target)
    -- Esta função exigiria o armazenamento do tempo restante em algum lugar, 
    -- o que não estamos fazendo atualmente
    return 0 -- Não implementado ainda
end)

-- Manipuladores de eventos
AddEventHandler("GP:SetGunpowderServer", function(state, weaponHash)
    exports[GetCurrentResourceName()]:SetGunpowderResidue(state, weaponHash)
end)

AddEventHandler("GP:CheckGunpowderServer", function()
    local hasResidue = exports[GetCurrentResourceName()]:HasGunpowderResidue()
    TriggerServerEvent("GP:CheckGunpowderResult", hasResidue)
end)

Citizen.CreateThread(function()
    repeat Wait(5000) until LocalPlayer.state.IsInSession
    if not LocalPlayer.state.Character then
        repeat Wait(1000) until LocalPlayer.state.Character
    end
    TriggerServerEvent("GP:CheckJob")
    AddEventHandler("GP:CheckJobResult", function(is_law)
        IsLaw = is_law
    end)
end)

-- checking command
RegisterCommand(command, function(source, args)
    local targetId = tonumber(args[1])

    if not IsLaw then
        Core.NotifyObjective("Não permitido", 4000)
        return
    end

    if not targetId then
        Dev("Uso: /gp [playerID]")
        return
    end

    -- get the player id from command
    local playerId = GetPlayerServerId(PlayerId())
    local targetPed = nil

    if targetId == playerId then
        targetPed = PlayerPedId()
    else
        targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    end

    if targetPed and DoesEntityExist(targetPed) then
        TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, 5000, 0, 0, false, false, false)
        progressbar.start("Verificando resíduos de pólvora", 5000, function()
            if DecorExistOn(targetPed, "HasShot") and DecorGetBool(targetPed, "HasShot") then
                Core.NotifyObjective("Esta pessoa " .. "disparou uma arma recentemente!", 5000)
                
                -- Se for desenvolver
                if Config.DevMode then
                    local weaponHash = DecorGetInt(targetPed, "GunpowderWeapon")
                    local washInfo = exports[GetCurrentResourceName()]:GetWashesInfo(targetPed)
                    Dev("Arma usada: " .. weaponHash)
                    Dev("Lavagens feitas: " .. washInfo.done .. "/" .. washInfo.required)
                end
            else
                Core.NotifyObjective("Esta pessoa " .. "está limpa.", 5000)
            end
        end, 'innercircle')
    else
        Core.NotifyObjective("Jogador não encontrado!", 4000)
    end
end, false)

local function isWeaponWhitelist(weaponHash)
    for _, allowedWeapon in ipairs(Config.WhitelistWeapons) do
        if weaponHash == allowedWeapon then
            return true
        end
    end
    return false
end

-- apply GP on someone that shot
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        if IsPedShooting(player) then
            local _, weaponHash = GetCurrentPedWeapon(player, true)
            Dev(weaponHash)
            if not isWeaponWhitelist(weaponHash) then
                Dev("Player shot a weapon (not whitelisted)")
                
                -- Use our export to set the gunpowder residue
                exports[GetCurrentResourceName()]:SetGunpowderResidue(true, weaponHash, player)
                
                Core.NotifyRightTip("Você tem resíduos de pólvora em você.", 4000)
            else
                Dev("Player used whitelisted weapon, ignoring")
            end
        end
    end
end)
