--====================================================
-- Kigahub Language System - 黒×白 / コンパクトガイド＆下寄せGUI / キーボードJ/Hキー対応
--====================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local savedLang = player:GetAttribute("KigaHubLang")

local CurrentGUI = nil
local CurrentGuide = nil

----------------------------------------------------------
-- 通知
----------------------------------------------------------
local function NotifyJP()
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "言語を日本語に設定しました。",
		Color = Color3.fromRGB(255, 255, 255)
	})
end

local function NotifyEN()
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "Language has been set to English.",
		Color = Color3.fromRGB(255, 255, 255)
	})
end

----------------------------------------------------------
-- UI削除
----------------------------------------------------------
local function CloseAllUI()
	if CurrentGUI then
		CurrentGUI:Destroy()
		CurrentGUI = nil
	end
	if CurrentGuide then
		CurrentGuide:Destroy()
		CurrentGuide = nil
	end
end

----------------------------------------------------------
-- 言語セット
----------------------------------------------------------
local function SetLanguage(lang)
	CloseAllUI()

	if lang == "JP" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLnoob106/Kigahub.free.jp/refs/heads/main/Kiga.lua"))()
		NotifyJP()
	elseif lang == "EN" then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLnoob106/Kigahub.free.en/refs/heads/main/Kiga.lua"))()
		NotifyEN()
	end

	player:SetAttribute("KigaHubLang", lang)
end

----------------------------------------------------------
-- ガイド UI（上の小さな帯、再選択＆キーボード操作説明 日本語・英語両対応）
----------------------------------------------------------
local function createGuideUI()
	local g = Instance.new("ScreenGui")
	g.Name = "KigaHubGuideUI"
	g.ResetOnSpawn = false
	g.Parent = player.PlayerGui

	local t = Instance.new("TextLabel", g)
	t.Size = UDim2.new(0, 600, 0, 110)
	t.Position = UDim2.new(0.5, -300, 0.02, 0)
	t.BackgroundTransparency = 0.35
	t.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.Font = Enum.Font.GothamBold
	t.TextScaled = false
	t.TextWrapped = true
	t.TextSize = 14
	t.BorderSizePixel = 0
	t.Text =
		"[Language Guide]\n" ..
		"日本語:  kigahub 日本語 / kigahub jp\n" ..
		"English:  kigahub english / kigahub en\n" ..
		"再選択 (Re-select):  kigahub 言語変更 / kigahub language change\n" ..
		"キーボード操作 (Keyboard):\n" ..
		"  Jキー (J key) で日本語選択 (Select Japanese)\n" ..
		"  Hキー (H key) で英語選択 (Select English)"

	return g
end

----------------------------------------------------------
-- 中央の言語選択 GUI（小型・黒背景白文字）
----------------------------------------------------------
local function createLangGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "KigaHubLangUI"
	gui.ResetOnSpawn = false
	gui.Parent = player.PlayerGui

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 260, 0, 140)
	frame.Position = UDim2.new(0.5, -130, 0.65, -70)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 2
	frame.BorderColor3 = Color3.fromRGB(255, 255, 255)

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundTransparency = 1
	title.Text = "Kigahub Language"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true

	local function createBtn(text, y)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -20, 0, 40)
		b.Position = UDim2.new(0, 10, 0, y)
		b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.Font = Enum.Font.GothamBold
		b.TextScaled = true
		b.BorderColor3 = Color3.fromRGB(255, 255, 255)
		b.BorderSizePixel = 2
		b.Text = text

		b.MouseEnter:Connect(function()
			b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end)
		b.MouseLeave:Connect(function()
			b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		end)

		return b
	end

	local jpBtn = createBtn("日本語 (Japanese)", 40)
	local enBtn = createBtn("English (英語)", 85)

	jpBtn.Parent = frame
	enBtn.Parent = frame

	jpBtn.MouseButton1Click:Connect(function()
		SetLanguage("JP")
	end)

	enBtn.MouseButton1Click:Connect(function()
		SetLanguage("EN")
	end)

	return gui
end

----------------------------------------------------------
-- キーボードでJ/Hキー押したら言語切替
----------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.J then
			SetLanguage("JP")
		elseif key == Enum.KeyCode.H then
			SetLanguage("EN")
		end
	end
end)

----------------------------------------------------------
-- 初回実行
----------------------------------------------------------
if savedLang == nil then
	CurrentGuide = createGuideUI()
	CurrentGUI = createLangGui()
else
	SetLanguage(savedLang)
end

----------------------------------------------------------
-- チャットコマンド対応
----------------------------------------------------------
player.Chatted:Connect(function(msg)
	local m = msg:lower()

	if m == "kigahub 日本語" or m == "kigahub jp" then
		SetLanguage("JP")
		return
	end
	if m == "kigahub english" or m == "kigahub en" then
		SetLanguage("EN")
		return
	end
	if m == "kigahub 言語変更" or m == "kigahub language change" then
		player:SetAttribute("KigaHubLang", nil)
		CloseAllUI()

		CurrentGuide = createGuideUI()
		CurrentGUI = createLangGui()

		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "言語選択メニューを再表示しました。",
			Color = Color3.fromRGB(255, 255, 255)
		})
	end
end)
