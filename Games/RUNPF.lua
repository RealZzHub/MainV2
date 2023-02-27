if not syn then -- Phantom Forces uses Actors but we bypass B), modified v3rm find (wont take credit)
	if _G.ActorBypassLoaded then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RealZzHub/MainV2/main/Games/PhantomForces.lua", true))()
	else
		local zzLPlayer = game:GetService("Players").LocalPlayer
		local zzTeleportService = game:GetService("TeleportService")
		local queue_on_teleport = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
		queue_on_teleport([[
			local zzWorkspace = game:GetService("Workspace")
			local zzReplicatedFirst = game:GetService("ReplicatedFirst")
			local zzRunService = game:GetService("RunService")
			zzReplicatedFirst.ChildAdded:Connect(function(v)
				if v:IsA("Actor") then
					zzReplicatedFirst.ChildAdded:Wait()
					for _,b in pairs(v:GetChildren()) do
						b.Parent = zzReplicatedFirst
					end
				end
			end)
			
			local old
			old = hookmetamethod(zzRunService.Stepped, "__index", function(self, index)
				local indexed = old(self, index)
				if index == "ConnectParallel" and not checkcaller() then
					hookfunction(indexed, newcclosure(function(signal, callback)
						return old(self, "Connect")(signal, function()
							return self:Wait() and callback()
						end)
					end))
				end
				return indexed
			end)
			_G.ActorBypassLoaded = true
			repeat wait() until game:IsLoaded() and zzWorkspace:FindFirstChild("MenuLobby")
			loadstring(game:HttpGet("https://raw.githubusercontent.com/RealZzHub/MainV2/main/Games/PhantomForces.lua", true))()
		]])
		wait(0.2)
		zzTeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end
else
    local Actor = getactors()[1]
    local Script = game:HttpGet("https://raw.githubusercontent.com/RealZzHub/MainV2/main/Games/PhantomForces.lua", true)
    syn.run_on_actor(Actor, Script)
end 
