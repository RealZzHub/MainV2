local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiwi-i/wallys-ui-fork/master/lib.lua", true))()
local Window = library:CreateWindow('Spawn Luckyblocks')
Window:Section('Luckyblock')
 
local normalblockb  = Window:Button("Spawn 1", function()
  game.ReplicatedStorage.SpawnLuckyBlock:FireServer()
end)
local normalblockl  = Window:Button("Spawn 25", function()
  for i =1,25 do
  game.ReplicatedStorage.SpawnLuckyBlock:FireServer()
  end
end)
Window:Section('Super Luckyblock')
local superblockb  = Window:Button("Spawn 1", function()
  game.ReplicatedStorage.SpawnSuperBlock:FireServer()
end)
local superblockl  = Window:Button("Spawn 25", function()
  for i =1,25 do
  game.ReplicatedStorage.SpawnSuperBlock:FireServer()
  end
end)
Window:Section('Rainbow Luckyblock [BEST]')
local rbblockb  = Window:Button("Spawn 1", function()
  game.ReplicatedStorage.SpawnRainbowBlock:FireServer()
end)
local rbblockl  = Window:Button("Spawn 25", function()
  for i =1,25 do
  game.ReplicatedStorage.SpawnRainbowBlock:FireServer()
  end
end)
Window:Section('Galaxy Luckyblock')
local galblockb  = Window:Button("Spawn 1", function()
  game.ReplicatedStorage.SpawnGalaxyBlock:FireServer()
end)
local galblockl  = Window:Button("Spawn 25", function()
  for i =1,25 do
  game.ReplicatedStorage.SpawnGalaxyBlock:FireServer()
  end
end)
