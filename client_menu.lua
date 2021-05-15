local mainMenu = RageUI.CreateMenu("Optimization Menu",  "Optimization Menu")
local index_vue, distance_vue = 2, 1.0
local index_ombre, distance_shadow = 2, 0.5

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)
        RageUI.IsVisible(mainMenu, function()
            RageUI.List("Shadow", {
                { Name = "Without", Value = 0.0 },
                { Name = "Normal", Value = 0.5 },
                { Name = "Complex", Value = 1.0 },
            }, index_ombre, "", {}, true, {
                onListChange = function(Index, Item)
                    index_ombre = Index 
                    distance_shadow = Item["Value"]
                end
            })

            RageUI.List("View distance", {
                { Name = "Near", Value = 0.5 },
                { Name = "Normal", Value = 1.0 },
                { Name = "Far", Value = 200.0 },
            }, index_vue, "", {}, true, {
                onListChange = function(Index, Item)
                    index_vue = Index 
                    distance_vue = Item["Value"]
                end
            })
        end, function()end)

        if IsControlJustReleased(0, 244) then
            RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
        end

        if RageUI.Visible(mainMenu) then 
            DisableControlAction(0, 140, true) --> DESACTIVER LA TOUCHE POUR PUNCH
            DisableControlAction(0, 172, true) --DESACTIVE CONTROLL HAUT  
        end

        OverrideLodscaleThisFrame(distance_vue)
        CascadeShadowsSetCascadeBoundsScale(distance_shadow)
    end
end)