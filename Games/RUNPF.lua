if not syn then -- Phantom Forces uses Actors
    game:GetService("Players").LocalPlayer:Kick("RealZzHub - Currently Synapse X only! (parallel lua support required)")
end
local Actor = getactors()[1]
local Script = game:HttpGet("https://raw.githubusercontent.com/RealZzHub/MainV2/main/Games/PhantomForces.lua", true)
syn.run_on_actor(Actor, Script)
