local prompt = false
local AnimalPrompt

local cart = {
	"supplywagon2",
	"supplywagon",
	"wagon05x",
	"wagon02x",
	"gatchuck",
	"chuckwagon002x",
	"chuckwagon000x",
	"cart07",
	"cart06",
	"cart04",
	"cart03",
	"cart01",
	"huntercart01",
	"ArmySupplyWagon"
 }


function SetupAnimalPrompt()
    Citizen.CreateThread(function()
        local str = 'Put on Wagon'
        AnimalPrompt = PromptRegisterBegin()
        PromptSetControlAction(AnimalPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(AnimalPrompt, str)
        PromptSetEnabled(AnimalPrompt, false)
        PromptSetVisible(AnimalPrompt, false)
        PromptSetHoldMode(AnimalPrompt, true)
        PromptRegisterEnd(AnimalPrompt)

    end)
end

Citizen.CreateThread(function()
	SetupAnimalPrompt()
	while true do 
		Wait(1000)
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
		forwardoffset = GetOffsetFromEntityInWorldCoords(ped, 2.0, 2.0, 0.0)
		local Pos2 = GetEntityCoords(ped)
		local targetPos = GetOffsetFromEntityInWorldCoords(obj3, -0.0, 1.1,-0.1)
		local rayCast = StartShapeTestRay(Pos2.x, Pos2.y, Pos2.z, forwardoffset.x, forwardoffset.y, forwardoffset.z,-1,ped,7)
		local A,hit,C,C,spot = GetShapeTestResult(rayCast)                
		local model = GetEntityModel(spot)
		cartcoords = GetEntityCoords(spot)
		for _,carts in pairs(cart) do
			if model == GetHashKey(carts) then
				print("Model", model)
				local animal = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
				if animal ~= false then
					if prompt == false then
						PromptSetEnabled(AnimalPrompt, true)
						PromptSetVisible(AnimalPrompt, true)
						prompt = true
					end
					if PromptHasHoldModeCompleted(AnimalPrompt) then
						PromptSetEnabled(AnimalPrompt, false)
						PromptSetVisible(AnimalPrompt, false)
						prompt = false
						animalcheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
						pedid = NetworkGetNetworkIdFromEntity(animalcheck)
						Citizen.InvokeNative(0xC7F0B43DCDC57E3D, PlayerPedId(), animalcheck, GetEntityCoords(PlayerPedId()), 10.0, true)
						DoScreenFadeOut(1800)
						Wait(2000)
						TriggerServerEvent('hunterwagon:teleportentity', pedid, cartcoords.x, cartcoords.y, cartcoords.z + 1.5)
						SetEntityCoords(animalcheck, cartcoords.x, cartcoords.y, cartcoords.z + 1.5, 0.0, 0.0, 0.0, false)
						DoScreenFadeIn(3000)
						Wait(2000)
					end

					forwardoffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
					local Pos2 = GetOffsetFromEntityInWorldCoords(ped, -0.0, 0.0, 0.5)
					local targetPos = GetOffsetFromEntityInWorldCoords(obj3, -0.0, 1.1, -0.1)
					local rayCast = StartShapeTestRay(Pos2.x, Pos2.y, Pos2.z, forwardoffset.x, forwardoffset.y, forwardoffset.z,-1,ped,7)
					A,hit,B,C,spot = GetShapeTestResult(rayCast)
					NetworkRequestControlOfEntity(animalcheck)
					model = GetEntityModel(spot)
				else
					PromptSetEnabled(AnimalPrompt, false)
					PromptSetVisible(AnimalPrompt, false)
					prompt = false
				end
			else
				PromptSetEnabled(AnimalPrompt, false)
				PromptSetVisible(AnimalPrompt, false)
				prompt = false
			end
		end
	end
end)

RegisterNetEvent('hunterwagon:teleportentitycl')
AddEventHandler('hunterwagon:teleportentitycl', function(netid,x,y,z)
	ent = NetworkGetEntityFromNetworkId(netid)
	Wait(150)
	SetEntityCoords(ent,x,y,z)
end)