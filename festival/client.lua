CreateThread(function()
    
    if config.command then
        local enable = false
        local particle_data = {}
        
        
        RegisterCommand("startfx", function()
            local playerPed = PlayerPedId()
            local distance = nil
            local playerCoords = nil
            
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
            else
                
                    enable = false
                    for k, v in pairs(particle_data) do
                        StopParticleFxLooped(v, false)
                    end
                    
                
            end
        end)
    else
        local particles = {}
        
        CreateThread(function()
            local playerPed = PlayerPedId()
            local playerCoords = nil
            while true do 
                Wait(500)
                playerCoords = GetEntityCoords(playerPed)
                print(json.encode(particles))
                for k, v in pairs(config.particles) do
                    if #(playerCoords - v.coords) <= 100 then
                        if not particles[v.name] then 
                            loadParticle(v.dict)
                            local particle_start = StartParticleFxLoopedAtCoord(v.name, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, v.scale, false, false, false, 0)
                            particles[v.name] = particle_start
                        end
                    elseif #(playerCoords - v.coords) > 100 then
                        if particles[v.name] then 
                            StopParticleFxLooped(particles[v.name], false)
                            particles[v.name] = nil
                        end
                    end
                end
            end
        end)
        
        function loadParticle(dict)
            RequestNamedPtfxAsset(dict)
            while not HasNamedPtfxAssetLoaded(dict) do
                Wait(100)
            end
            UseParticleFxAsset(dict)
        end
        
    end    
end)