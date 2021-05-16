local mainMenu = RageUI.CreateMenu("Optimization Menu",  "Optimization Menu")
local index_vue_lod, index_ombre = 2, 2
local startOpti = false

AddEventHandler("playerSpawned", function()
	Wait(1000)
	init()
end)

function init()
    distance_vue_lod = GetResourceKvpFloat("view_lod")
    distance_shadow = GetResourceKvpFloat("dist_shadow")
	if distance_vue_lod == 0.0 then
        distance_vue_lod = 1.0
        distance_shadow = 0.5
        SetResourceKvpFloat("view_lod", distance_vue_lod)
        SetResourceKvpFloat("dist_shadow", distance_shadow)
    end
	startOpti = true
end

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1)
		if startOpti then
            RageUI.IsVisible(mainMenu, function()
                RageUI.List("Cascade Shadow", {
                    { Name = "Without", Value = 0.0 },
                    { Name = "Normal", Value = 0.5 },
                    { Name = "Complex", Value = 1.0 },
                }, index_ombre, "", {}, true, {
                    onListChange = function(Index, Item)
                        index_ombre = Index 
                        distance_shadow = Item["Value"]
                        SetResourceKvpFloat("dist_shadow", distance_shadow)
                    end
                })
		    
                RageUI.List("Lod View distance", {
                    { Name = "Near", Value = 0.5 },
                    { Name = "Normal", Value = 1.0 },
                    { Name = "Far", Value = 200.0 },
                }, index_vue_lod, "", {}, true, {
                    onListChange = function(Index, Item)
                        index_vue_lod = Index 
                        distance_vue_lod = Item["Value"]
                        SetResourceKvpFloat("view_lod", distance_vue_lod)
                    end
                })
            end, function()end)
		    
            if RageUI.Visible(mainMenu) then
                DisableControlAction(0, 140, true) --> DESACTIVER LA TOUCHE POUR PUNCH
                DisableControlAction(0, 172, true) --DESACTIVE CONTROLL HAUT  
            end
		
		    OverrideLodscaleThisFrame(distance_vue_lod)
            SetLightsCutoffDistanceTweak(distance_vue_lod)
            CascadeShadowsSetCascadeBoundsScale(distance_shadow)
		end
    end
end)

RegisterCommand('+menuopti', function()
    Wait(100)
	RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
end, false)
RegisterCommand('-menuopti', function()
end, false)
RegisterKeyMapping('+menuopti', 'GTA Optimization', 'keyboard', 'M')
