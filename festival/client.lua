local enable = false
local particle_data = {}


RegisterCommand("startfx", function()
    local playerPed = PlayerPedId()
    local playerCoords = nil
    local distance = nil

    playerCoords = GetEntityCoords(playerPed)

    if not enable then
        enable = true

        for k, v in pairs(config.particles) do
            distance = #(playerCoords - v.coords)

            if distance <= 100 then
                RequestNamedPtfxAsset(v.dict)
                
                while not HasNamedPtfxAssetLoaded(v.dict) do
                    Wait(1)
                end

                UseParticleFxAsset(v.dict)
                local particle = StartParticleFxLoopedAtCoord(v.name, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, v.scale, false, false, false, 0)
                table.insert(particle_data, particle)
            end
        end
        return
    else
        if distance >= 100 then 
            enable = false
            for k, v in pairs(particle_data) do
                StopParticleFxLooped(v, false)
            end
            return
        end
    end
end)