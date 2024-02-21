setfflag("DebugRunParallelLuaOnMainThread", "True")
queue_on_teleport([[
repeat wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RealZzHub/MainV2/main/Games/PhantomForces.lua", true))()
]])
wait(0.2)
zzTeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)

