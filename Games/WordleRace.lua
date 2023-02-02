if not isfile("wordlewords.txt") then
	writefile("wordlewords.txt", game:HttpGetAsync("https://raw.githubusercontent.com/RealZzHub/MainV2/main/Misc/WordleWords.txt"))
end
local WordsTXT = readfile("wordlewords.txt")
local Words = {}
for word in WordsTXT:gmatch('%a+') do
	Words[#Words + 1] = word
end
local v8 = {
	[-1] = Color3.fromRGB(33, 33, 33),
	[0] = Color3.fromRGB(17, 17, 17),
	[1] = Color3.fromRGB(255, 204, 101),
	[2] = Color3.fromRGB(89, 214, 82)
}
local u1 = {}
function DoKeyboardShitToo(Data, Word)
	wait()
	for i, v in pairs(Word:split("")) do
		local v21 = {
			[v] = Data[i]
		}
		if u1[v] and u1[v] < v21[v] then
			u1[v] = v21[v]
			for a, b in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Keyboard:GetDescendants()) do
				if b.Name:lower() == v:lower() then
					if Data[i] == 0 then
						b.UIStroke.Thickness = 1
						b.UIStroke.Transparency = 0
						b.UIStroke.Color = Color3.fromRGB(255, 0, 98)
						game:GetService("ReplicatedStorage").Remotes.RoundStatus.OnClientEvent:Connect(function()
							b.UIStroke.Thickness = 0
							b.UIStroke.Transparency = 1
							b.UIStroke.Color = Color3.fromRGB(255, 255, 255)
						end)
					else
						b.UIStroke.Thickness = 0
						b.UIStroke.Transparency = 1
						b.UIStroke.Color = Color3.fromRGB(255, 255, 255)
					end
					game:GetService("TweenService"):Create(b, TweenInfo.new(0.5), {
						BackgroundColor3 = v8[Data[i]]
					}):Play()
				end
			end
		end
	end
end
function DoGameShitXD(Data, Word)
	if Data[1] == true then
		DoKeyboardShitToo(Data[2], Word)
		local v27 = workspace.Board.Rows:FindFirstChild("Row" .. tostring(Data[3] - 1))
		game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.entertext.Text = ""
		wait(0.1)
		for i, v in pairs(Data[2]) do
			local v30 = v27:FindFirstChild(tostring(i))
			game:GetService("TweenService"):Create(v30, TweenInfo.new(0.1), {
				Color = v8[Data[2][i]]
			}):Play()
			v27:FindFirstChild("Letters"):ClearAllChildren()
			for a, b in pairs(Word:split("")) do
				local v34 = game:GetService("ReplicatedStorage").Items.Fonts.Default:FindFirstChild(b:upper()):Clone()
				if v34 then
					v34.Size = v34.Size * (workspace.Board.Rows.Row1:FindFirstChild("1").Size.Y / v34.Size.Y / 2)
					v34.CFrame = v27:FindFirstChild(tostring(a)).CFrame * CFrame.new(-workspace.Board.Rows.Row1:FindFirstChild("1").Size.X / 2 - 0, 0, 0) * CFrame.fromEulerAnglesXYZ(0, 1.5707963267948966, 0)
					v34.Parent = v27:FindFirstChild("Letters")
				end
			end
		end
	end
end
function Guess(word)
	game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.entertext.Text = word:lower()
	return game:GetService("ReplicatedStorage").Remotes.Submit:InvokeServer(word:lower())
end
local UsableWords = Words
function FindWords(data)
	local FoundWords = {}
	for i, v in pairs(UsableWords) do
		task.spawn(function()
			for _, BLetter in pairs(data.BLetters) do
				if v:find(BLetter) then
					return
				end
			end
			for _, YData in pairs(data.YLetters) do
				if not v:find(YData[1]) or v:sub(YData[2], YData[2]) == YData[1] then
					return
				end
			end
			for LetterPos, GLetter in pairs(data.GLetters) do
				if GLetter ~= nil and v:sub(LetterPos, LetterPos) ~= GLetter then
					return
				end
			end
			table.insert(FoundWords, v)
		end)
	end
	UsableWords = FoundWords
	return FoundWords
end
local RightGuesses = 0
local LastWord = ""
function DoNext(Word, NewData)
	Word = Word:lower()
	local Data = {
		YLetters = {},
		GLetters = {
			[1] = nil,
			[2] = nil,
			[3] = nil,
			[4] = nil,
			[5] = nil
		},
		BLetters = {}
	}
	if NewData then
		Data = NewData
	end
	local GuessData = Guess(Word)
	DoGameShitXD(GuessData, Word:lower())
	if GuessData[1] then
		RightGuesses = RightGuesses + 1
		LastWord = Word:lower()
		for i, v in pairs(GuessData[2]) do
			local Letter = Word:sub(i, i)
			if v == 0 and not table.find(Data.BLetters, Letter) and not table.find(Data.YLetters, Letter) then
				table.insert(Data.BLetters, Letter)
			end
			if v == 1 and not table.find(Data.YLetters, Letter) then
				table.insert(Data.YLetters, {
					Letter,
					i
				})
			end
			if v == 2 and Data.GLetters[i] ~= Letter then
				Data.GLetters[i] = Letter
			end
		end
		return FindWords(Data), Data
	else
		local mWords = FindWords(Data)
		if RightGuesses < 6 and #mWords ~= 1 then
			local ChosenWord = mWords[math.random(1, #mWords)]
			return DoNext(ChosenWord, Data)
		else
			return false
		end
	end
end
local Mode = "Smart"
local BestWords = {"adept","clamp","plaid"}
local Guessing = false
function Start()
	local RoundEndVal = game:GetService("ReplicatedStorage").roundEnd.Value
	local OSTimeVal = game:GetService("ReplicatedStorage").ostime.Value
	if OSTimeVal > RoundEndVal or Guessing or game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.entertext.Position.Y.Scale > 0.93 then
		return
	end
	Guessing = true
	local mWords, Data
	if Mode == "Smart" then
		mWords, Data = DoNext(BestWords[math.random(1, #BestWords)])
	else
		mWords, Data = DoNext(Words[math.random(1, #Words)])
	end
	for i = 1, 5 do
		OSTimeVal = game:GetService("ReplicatedStorage").ostime.Value
		if mWords == false or #mWords < 1 or not Guessing or game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.entertext.Position.Y.Scale > 0.93 or OSTimeVal > RoundEndVal then
			UsableWords = Words
			Guessing = false
			break
		end
		local ChosenWord = mWords[math.random(1, #mWords)]
		mWords, Data = DoNext(ChosenWord, Data)
	end
	UsableWords = Words
	Guessing = false
end
local AutoStartGuessing = false
local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealZzHub/Main/main/UILibV2.lua", true))():Main("Wordle Race")
MainTab = Main:NewTab("Main")
MainTab:NewLabel("Guessing", true)
MainTab:NewToggle("Auto Start Guessing", function(state)
	AutoStartGuessing = state
end)
MainTab:NewButton("Start Guessing", function()
	Start()
end)
MainTab:NewDropdown("Mode", {"Smart","Normal"}, function(v)
	Mode = v
end, true)
MainTab:NewLabel("Misc", true)
MainTab:NewToggle("Anti AFK", function(state)
	for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
		if state then
			v:Disable()
		else
			v:Enable()
		end
	end
end)
game:GetService("RunService").RenderStepped:Connect(function()
	local RoundEndVal = game:GetService("ReplicatedStorage").roundEnd.Value
	local OSTimeVal = game:GetService("ReplicatedStorage").ostime.Value
	if AutoStartGuessing and not Guessing and OldRoundEndVal ~= RoundEndVal then
		OldRoundEndVal = RoundEndVal
		Start()
	end
end)
