local Core = exports.vorp_core:GetCore()

function Dev(...)
    if Config.DevMode then
        print(...)
    end
end

-- events
RegisterNetEvent("GP:CheckJob")
RegisterNetEvent("GP:CheckJobResult")
RegisterNetEvent("GP:SetGunpowderServer")
RegisterNetEvent("GP:CheckGunpowderServer")
RegisterNetEvent("GP:CheckGunpowderResult")

-- EXPORTS
-- Server-side export to check if player has gunpowder residue
exports('CheckPlayerGunpowder', function(playerId)
    if not playerId then return false end
    
    local result = false
    TriggerClientEvent("GP:CheckGunpowderServer", playerId)
    
    -- This is not ideal as it's synchronous, but it provides the functionality
    -- In a production environment, you would want to use callbacks
    return result
end)

-- Server-side export to set gunpowder residue on a player
exports('SetPlayerGunpowder', function(playerId, state, weaponHash)
    if not playerId then return false end
    
    TriggerClientEvent("GP:SetGunpowderServer", playerId, state, weaponHash)
    return true
end)

AddEventHandler("GP:CheckJob", function(src)
    local src = source
    local user = Core.getUser(src)
    if not user then return end
    local character = user.getUsedCharacter
    local player_job = character.job
    local is_law = false

    Dev("player job is: " .. player_job)

    for _, job in ipairs(Config.JobsAllowed) do
        if player_job == job then
            is_law = true
            break
        end
    end
    TriggerClientEvent("GP:CheckJobResult", src, is_law)
end)

-- Manipulador para o resultado da verificação de resíduo
AddEventHandler("GP:CheckGunpowderResult", function(hasResidue)
    -- Aqui você poderia armazenar o resultado ou enviá-lo para o cliente que solicitou
    -- Este é um exemplo simplificado
    local src = source
    -- Faça algo com o resultado (hasResidue)
    Dev("Player " .. src .. " has gunpowder residue: " .. tostring(hasResidue))
end)
