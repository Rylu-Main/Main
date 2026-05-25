--!nocheck

-- Fallbacks for non-executor environments
local cloneref = cloneref or function(x: any): any return x end
local gethui   = gethui   or function(): Instance return game:GetService("CoreGui") end

local TweenService: TweenService = cloneref(game:GetService("TweenService"))
local UIS: UserInputService      = cloneref(game:GetService("UserInputService"))
local Players: Players           = cloneref(game:GetService("Players"))
local RunService: RunService     = cloneref(game:GetService("RunService"))
local player: Player             = Players.LocalPlayer

-- ANTI-DUPE
local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("4557HubGui")
	or gethui():FindFirstChild("4557HubGui")
if existingGui then existingGui:Destroy() end
if _G["4557Running"] then
	_G["4557Running"] = false
	if _G["4557Connection"] then
		(_G["4557Connection"] :: RBXScriptConnection):Disconnect()
		_G["4557Connection"] = nil
	end
end
_G["4557Running"] = true

local Lib   = {}
Lib.__index = Lib

-- Parent to gethui() so it survives resets and stays hidden from PlayerGui scans
local _gui: ScreenGui = Instance.new("ScreenGui")
_gui.Name           = "4557HubGui"
_gui.ResetOnSpawn   = false
_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_gui.Parent         = gethui()

local WIN_W: number  = 220
local WIN_MAR: number= 15
local WIN_Y: number  = 10
local _windows: {any}       = {}
local _loaded: boolean      = false
local _pendingShow: {() -> ()} = {}

-- HELPERS
local function _style(obj: GuiObject)
	Instance.new("UICorner", obj)
	local s: UIStroke = Instance.new("UIStroke", obj)
	s.Color     = Color3.fromRGB(50, 50, 50)
	s.Thickness = 1
end

local function _reposition()
	local vis: {Frame} = {}
	for _, w in ipairs(_windows) do
		if w.shown then
			table.insert(vis, w.frame)
		end
	end
	local n: number = #vis
	if n == 0 then return end
	local sw: number = workspace.CurrentCamera.ViewportSize.X
	local pos: {number} = {}
	if n == 1 then
		pos = { WIN_MAR }
	elseif n == 2 then
		pos = { WIN_MAR, sw - WIN_W - WIN_MAR }
	else
		local gap = math.max((sw - WIN_MAR * 2 - WIN_W * n) / (n - 1), WIN_MAR)
		for i = 1, n do
			pos[i] = WIN_MAR + (i - 1) * (WIN_W + gap)
		end
	end
	for i, frame in ipairs(vis) do
		local x = math.clamp(pos[i] or WIN_MAR, 0, sw - WIN_W)
		TweenService:Create(
			frame,
			TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0, x, 0, WIN_Y) }
		):Play()
	end
end

-- CREATE WINDOW
function Lib:CreateWindow(title: string)

	local winData: {[string]: any} = { shown = false }
	table.insert(_windows, winData)

	local frame: Frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0, WIN_W, 0, 100)
	frame.Position         = UDim2.new(0, WIN_MAR, 0, WIN_Y)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.ClipsDescendants = true
	frame.Active           = true
	frame.Visible          = false
	frame.ZIndex           = 10
	frame.Parent           = _gui
	Instance.new("UICorner", frame)
	local fStroke: UIStroke = Instance.new("UIStroke", frame)
	fStroke.Color     = Color3.fromRGB(40, 40, 40)
	fStroke.Thickness = 1

	winData.frame = frame

	local titleBar: TextLabel = Instance.new("TextLabel")
	titleBar.Size             = UDim2.new(1, 0, 0, 40)
	titleBar.Text             = string.upper(title or "Window")
	titleBar.Font             = Enum.Font.LuckiestGuy
	titleBar.TextSize         = 16
	titleBar.TextColor3       = Color3.new(1, 1, 1)
	titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	titleBar.Active           = true
	titleBar.Parent           = frame
	Instance.new("UICorner", titleBar)

	local colBtn: TextButton = Instance.new("TextButton")
	colBtn.Size               = UDim2.new(0, 30, 0, 30)
	colBtn.Position           = UDim2.new(1, -35, 0.5, -15)
	colBtn.Text               = " "
	colBtn.BackgroundTransparency = 1
	colBtn.Font               = Enum.Font.GothamBold
	colBtn.TextSize           = 18
	colBtn.TextColor3         = Color3.new(1, 1, 1)
	colBtn.Parent             = titleBar

	local scroll: ScrollingFrame = Instance.new("ScrollingFrame")
	scroll.Size                = UDim2.new(1, 0, 1, -40)
	scroll.Position            = UDim2.new(0, 0, 0, 40)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness  = 6
	scroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
	scroll.Parent              = frame

	local layout: UIListLayout = Instance.new("UIListLayout")
	layout.Padding   = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent    = scroll

	local pad: UIPadding = Instance.new("UIPadding")
	pad.PaddingTop    = UDim.new(0, 5)
	pad.PaddingBottom = UDim.new(0, 5)
	pad.PaddingLeft   = UDim.new(0, 5)
	pad.PaddingRight  = UDim.new(0, 5)
	pad.Parent        = scroll

	local collapsed: boolean = false
	local function updateCanvas()
		task.defer(function()
			scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
			if not collapsed then
				frame.Size = UDim2.new(0, WIN_W, 0,
					math.clamp(layout.AbsoluteContentSize.Y + 50, 100, 400))
			end
		end)
	end
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

	colBtn.MouseButton1Click:Connect(function()
		collapsed = not collapsed
		if collapsed then
			colBtn.Text = " "
			TweenService:Create(frame, TweenInfo.new(0.25),
				{ Size = UDim2.new(0, WIN_W, 0, 40) }):Play()
		else
			colBtn.Text = " "
			TweenService:Create(frame, TweenInfo.new(0.25), {
				Size = UDim2.new(0, WIN_W, 0,
					math.clamp(layout.AbsoluteContentSize.Y + 50, 100, 400))
			}):Play()
		end
	end)

	-- DRAG
	local dragging: boolean  = false
	local dragStart: Vector3 = Vector3.zero
	local startPos: UDim2   = UDim2.new()

	titleBar.InputBegan:Connect(function(i: InputObject)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch
		then
			dragging  = true
			dragStart = i.Position
			startPos  = frame.Position
		end
	end)
	titleBar.InputEnded:Connect(function(i: InputObject)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch
		then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i: InputObject)
		if not dragging then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement
			or i.UserInputType == Enum.UserInputType.Touch
		then
			local sc: Vector2 = workspace.CurrentCamera.ViewportSize
			local delta: Vector3 = i.Position - dragStart
			local newX = math.clamp(startPos.X.Offset + delta.X, 0, math.max(0, sc.X - frame.AbsoluteSize.X))
			local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, math.max(0, sc.Y - frame.AbsoluteSize.Y))
			frame.Position = UDim2.new(0, newX, 0, newY)
		end
	end)

	-- ANTI OUT OF SCREEN
	RunService.RenderStepped:Connect(function()
		if not frame or not frame.Parent then return end
		local sc: Vector2 = workspace.CurrentCamera.ViewportSize
		local pos = frame.Position
		local x = math.clamp(pos.X.Offset, 0, math.max(0, sc.X - frame.AbsoluteSize.X))
		local y = math.clamp(pos.Y.Offset, 0, math.max(0, sc.Y - frame.AbsoluteSize.Y))
		if x ~= pos.X.Offset or y ~= pos.Y.Offset then
			frame.Position = UDim2.new(0, x, 0, y)
		end
	end)

	if _loaded then
		winData.shown = true
		frame.Visible = true
		_reposition()
	else
		table.insert(_pendingShow, function()
			winData.shown = true
			frame.Visible = true
		end)
	end

	local Win    = {}
	local _order: number = 0
	local function nxt(): number _order += 1; return _order end

	function Win:SetTitle(text: string)
		titleBar.Text = string.upper(text or "Window")
	end
	function Win:SetPosition(x: number, y: number)
		frame.Position = UDim2.new(0, x, 0, y)
	end

	function Win:Label(text: string)
		local lbl: TextLabel = Instance.new("TextLabel")
		lbl.Size                  = UDim2.new(1, 0, 0, 30)
		lbl.Text                  = text or "Label"
		lbl.BackgroundTransparency = 1
		lbl.TextColor3            = Color3.fromRGB(255, 255, 255)
		lbl.Font                  = Enum.Font.GothamBlack
		lbl.TextSize              = 16
		lbl.TextXAlignment        = Enum.TextXAlignment.Center
		lbl.LayoutOrder           = nxt()
		lbl.Parent                = scroll
		local lp: UIPadding = Instance.new("UIPadding")
		lp.PaddingLeft = UDim.new(0, 8)
		lp.Parent      = lbl
		updateCanvas()
		return lbl
	end

	function Win:Section(text: string)
		local sec: Frame = Instance.new("Frame")
		sec.Size                  = UDim2.new(1, 0, 0, 26)
		sec.BackgroundTransparency = 1
		sec.LayoutOrder           = nxt()
		sec.Parent                = scroll
		local lineL: Frame = Instance.new("Frame")
		lineL.Size             = UDim2.new(0.28, 0, 0, 1)
		lineL.Position         = UDim2.new(0, 5, 0.5, 0)
		lineL.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
		lineL.BorderSizePixel  = 0
		lineL.Parent           = sec
		local lineR: Frame = Instance.new("Frame")
		lineR.Size             = UDim2.new(0.28, 0, 0, 1)
		lineR.Position         = UDim2.new(0.72, 0, 0.5, 0)
		lineR.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
		lineR.BorderSizePixel  = 0
		lineR.Parent           = sec
		local sLbl: TextLabel = Instance.new("TextLabel")
		sLbl.Size                  = UDim2.new(0.4, 0, 1, 0)
		sLbl.Position              = UDim2.new(0.3, 0, 0, 0)
		sLbl.BackgroundTransparency = 1
		sLbl.Text                  = text or ""
		sLbl.TextColor3            = Color3.fromRGB(110, 110, 110)
		sLbl.Font                  = Enum.Font.GothamBold
		sLbl.TextSize              = 13
		sLbl.Parent                = sec
		updateCanvas()
	end

	function Win:Button(text: string, callback: () -> ())
		local btn: TextButton = Instance.new("TextButton")
		btn.Size             = UDim2.new(1, 0, 0, 40)
		btn.Text             = text or "Button"
		btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		btn.TextColor3       = Color3.fromRGB(255, 255, 255)
		btn.Font             = Enum.Font.GothamBold
		btn.TextSize         = 16
		btn.LayoutOrder      = nxt()
		btn.TextXAlignment   = Enum.TextXAlignment.Left
		btn.Parent           = scroll
		_style(btn)
		local bp: UIPadding = Instance.new("UIPadding")
		bp.PaddingLeft  = UDim.new(0, 10)
		bp.PaddingRight = UDim.new(0, 30)
		bp.Parent       = btn
		local arr: ImageLabel = Instance.new("ImageLabel")
		arr.Size               = UDim2.new(0, 20, 0, 20)
		arr.AnchorPoint        = Vector2.new(1, 0.5)
		arr.Position           = UDim2.new(1, 12, 0.5, 0)
		arr.ZIndex             = btn.ZIndex + 1
		arr.BackgroundTransparency = 1
		arr.Image              = "rbxthumb://type=Asset&id=13306021335&w=420&h=420"
		arr.ImageColor3        = Color3.fromRGB(200, 200, 200)
		arr.Parent             = btn
		btn.MouseButton1Click:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0), { BackgroundColor3 = Color3.fromRGB(220, 20, 60) }):Play()
			task.wait(0)
			TweenService:Create(btn, TweenInfo.new(0), { BackgroundColor3 = Color3.fromRGB(25, 25, 25) }):Play()
			if callback then pcall(callback) end
		end)
		updateCanvas()
		return btn
	end

	function Win:Toggle(text: string, default: boolean, callback: (boolean) -> ())
		local state: boolean = default or false
		local row: TextButton = Instance.new("TextButton")
		row.Size             = UDim2.new(1, 0, 0, 40)
		row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		row.Text             = ""
		row.LayoutOrder      = nxt()
		row.Parent           = scroll
		_style(row)
		local lbl: TextLabel = Instance.new("TextLabel")
		lbl.Size               = UDim2.new(1, -50, 1, 0)
		lbl.Position           = UDim2.new(0, 10, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text               = text or "Toggle"
		lbl.Font               = Enum.Font.GothamBold
		lbl.TextSize           = 16
		lbl.TextColor3         = Color3.new(1, 1, 1)
		lbl.TextXAlignment     = Enum.TextXAlignment.Left
		lbl.Parent             = row
		local box: Frame = Instance.new("Frame")
		box.Size             = UDim2.new(0, 24, 0, 24)
		box.Position         = UDim2.new(1, -34, 0.5, -12)
		box.BackgroundColor3 = state and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 40, 40)
		box.Parent           = row
		Instance.new("UICorner", box)
		row.MouseButton1Click:Connect(function()
			state = not state
			box.BackgroundColor3 = state and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 40, 40)
			if callback then pcall(callback, state) end
		end)
		updateCanvas()
		local T = {}
		function T:Set(v: boolean)
			state = v
			box.BackgroundColor3 = v and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 40, 40)
		end
		function T:Get(): boolean return state end
		return T
	end

	function Win:Slider(text: string, min: number, max: number, default: number, callback: (number) -> ())
		min = min or 0; max = max or 100
		local val: number = math.clamp(default or min, min, max)
		local cont: Frame = Instance.new("Frame")
		cont.Size             = UDim2.new(1, 0, 0, 70)
		cont.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		cont.LayoutOrder      = nxt()
		cont.Parent           = scroll
		_style(cont)
		local tLbl: TextLabel = Instance.new("TextLabel")
		tLbl.Size               = UDim2.new(0.6, 0, 0, 20)
		tLbl.Position           = UDim2.new(0, 10, 0, 5)
		tLbl.Text               = text or "Slider"
		tLbl.Font               = Enum.Font.GothamBold
		tLbl.TextSize           = 16
		tLbl.TextXAlignment     = Enum.TextXAlignment.Left
		tLbl.TextColor3         = Color3.new(1, 1, 1)
		tLbl.BackgroundTransparency = 1
		tLbl.Parent             = cont
		local numBox: Frame = Instance.new("Frame")
		numBox.Size             = UDim2.new(0.15, 0, 0, 24)
		numBox.Position         = UDim2.new(0.85, 0, 0, 5)
		numBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		numBox.BorderColor3     = Color3.fromRGB(100, 100, 100)
		numBox.BorderSizePixel  = 2
		numBox.Parent           = cont
		Instance.new("UICorner", numBox)
		local valTxt: TextBox = Instance.new("TextBox")
		valTxt.Size               = UDim2.new(1, 0, 1, 0)
		valTxt.BackgroundTransparency = 1
		valTxt.Text               = tostring(val)
		valTxt.Font               = Enum.Font.GothamBold
		valTxt.TextSize           = 14
		valTxt.TextColor3         = Color3.fromRGB(200, 200, 200)
		valTxt.ClearTextOnFocus   = false
		valTxt.TextXAlignment     = Enum.TextXAlignment.Center
		valTxt.TextYAlignment     = Enum.TextYAlignment.Center
		valTxt.Parent             = numBox
		local bar: Frame = Instance.new("Frame")
		bar.Size             = UDim2.new(0.95, -10, 0, 10)
		bar.Position         = UDim2.new(0, 10, 0.6, 0)
		bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		bar.Parent           = cont
		Instance.new("UICorner", bar)
		local ip: number = (val - min) / (max - min)
		local fill: Frame = Instance.new("Frame")
		fill.Size             = UDim2.new(ip, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
		fill.Parent           = bar
		Instance.new("UICorner", fill)
		local knob: Frame = Instance.new("Frame")
		knob.Size             = UDim2.new(0, 16, 0, 16)
		knob.AnchorPoint      = Vector2.new(0.5, 0.5)
		knob.Position         = UDim2.new(ip, 0, 0.5, 0)
		knob.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
		knob.Parent           = bar
		Instance.new("UICorner", knob)
		local sliderDrag: boolean = false
		local function setPos(pos: number)
			pos       = math.clamp(pos, 0, 1)
			fill.Size     = UDim2.new(pos, 0, 1, 0)
			knob.Position = UDim2.new(pos, 0, 0.5, 0)
			val           = math.floor(min + pos * (max - min))
			valTxt.Text   = tostring(val)
			if callback then pcall(callback, val) end
		end
		bar.InputBegan:Connect(function(i: InputObject)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch
			then
				sliderDrag = true
				setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
			end
		end)
		UIS.InputChanged:Connect(function(i: InputObject)
			if sliderDrag and (i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch)
			then
				setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
			end
		end)
		UIS.InputEnded:Connect(function(i: InputObject)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch
			then
				sliderDrag = false
			end
		end)
		valTxt.FocusLost:Connect(function(enter: boolean)
			if enter then
				local v = tonumber(valTxt.Text)
				if v then
					val = math.clamp(v, min, max)
					local p = (val - min) / (max - min)
					fill.Size     = UDim2.new(p, 0, 1, 0)
					knob.Position = UDim2.new(p, 0, 0.5, 0)
					valTxt.Text   = tostring(val)
					if callback then pcall(callback, val) end
				else
					valTxt.Text = tostring(val)
				end
			end
		end)
		updateCanvas()
		local S = {}
		function S:Set(v: number)
			val = math.clamp(v, min, max)
			local p = (val - min) / (max - min)
			fill.Size     = UDim2.new(p, 0, 1, 0)
			knob.Position = UDim2.new(p, 0, 0.5, 0)
			valTxt.Text   = tostring(val)
		end
		function S:Get(): number return val end
		return S
	end

	function Win:Dropdown(headerText: string, options: {string}, callback: (string) -> ())
		local selected: string = "Select Option"
		local dropBtn: TextButton = Instance.new("TextButton")
		dropBtn.Size             = UDim2.new(1, 0, 0, 50)
		dropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		dropBtn.Text             = ""
		dropBtn.LayoutOrder      = nxt()
		dropBtn.Parent           = scroll
		_style(dropBtn)
		local headLbl: TextLabel = Instance.new("TextLabel")
		headLbl.Size               = UDim2.new(1, -10, 0, 18)
		headLbl.Position           = UDim2.new(0, 5, 0, 2)
		headLbl.BackgroundTransparency = 1
		headLbl.Text               = headerText or "Dropdown"
		headLbl.TextColor3         = Color3.fromRGB(170, 170, 170)
		headLbl.Font               = Enum.Font.Gotham
		headLbl.TextSize           = 13
		headLbl.TextXAlignment     = Enum.TextXAlignment.Left
		headLbl.Parent             = dropBtn
		local selLbl: TextLabel = Instance.new("TextLabel")
		selLbl.Size               = UDim2.new(1, -25, 1.3, 0)
		selLbl.Position           = UDim2.new(0, 5, 0, 0)
		selLbl.BackgroundTransparency = 1
		selLbl.Text               = selected
		selLbl.TextColor3         = Color3.new(1, 1, 1)
		selLbl.Font               = Enum.Font.GothamBold
		selLbl.TextSize           = 16
		selLbl.TextXAlignment     = Enum.TextXAlignment.Left
		selLbl.Parent             = dropBtn
		local arrowLbl: TextLabel = Instance.new("TextLabel")
		arrowLbl.Size               = UDim2.new(0, 20, 1, 0)
		arrowLbl.Position           = UDim2.new(1, -20, 0, 0)
		arrowLbl.BackgroundTransparency = 1
		arrowLbl.Text               = "▼"
		arrowLbl.TextColor3         = Color3.fromRGB(200, 200, 200)
		arrowLbl.Font               = Enum.Font.GothamBold
		arrowLbl.TextSize           = 20
		arrowLbl.TextXAlignment     = Enum.TextXAlignment.Center
		arrowLbl.Parent             = dropBtn
		local dropFrame: Frame = Instance.new("Frame")
		dropFrame.Size             = UDim2.new(1, 0, 0, 0)
		dropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		dropFrame.ClipsDescendants = true
		dropFrame.LayoutOrder      = nxt()
		dropFrame.Active           = false
		dropFrame.Parent           = scroll
		Instance.new("UICorner", dropFrame)
		Instance.new("UIListLayout", dropFrame)
		local open: boolean = false
		for _, v in ipairs(options or {}) do
			local opt: TextButton = Instance.new("TextButton")
			opt.Size             = UDim2.new(1, 0, 0, 30)
			opt.Active           = true
			opt.Text             = v
			opt.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			opt.TextColor3       = Color3.new(1, 1, 1)
			opt.Font             = Enum.Font.GothamBold
			opt.TextSize         = 14
			opt.Parent           = dropFrame
			_style(opt)
			opt.MouseButton1Click:Connect(function()
				selected      = v
				selLbl.Text   = v
				open          = false
				TweenService:Create(dropFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 0) }):Play()
				task.wait(0.21)
				updateCanvas()
				if callback then pcall(callback, v) end
			end)
		end
		dropBtn.MouseButton1Click:Connect(function()
			open = not open
			local h: number = open and (#options * 30) or 0
			TweenService:Create(dropFrame, TweenInfo.new(0.25), { Size = UDim2.new(1, 0, 0, h) }):Play()
			task.delay(0.26, updateCanvas)
		end)
		updateCanvas()
		local D = {}
		function D:Get(): string return selected end
		function D:Set(v: string) selected = v; selLbl.Text = v end
		return D
	end

	function Win:CreateFolder(folderName: string)
		local tabBtn: TextButton = Instance.new("TextButton")
		tabBtn.Size             = UDim2.new(1, 0, 0, 34)
		tabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		tabBtn.TextColor3       = Color3.fromRGB(180, 180, 180)
		tabBtn.Font             = Enum.Font.GothamBold
		tabBtn.TextSize         = 14
		tabBtn.Text             = "▶  " .. (folderName or "Folder")
		tabBtn.TextXAlignment   = Enum.TextXAlignment.Left
		tabBtn.LayoutOrder      = nxt()
		tabBtn.Parent           = scroll
		_style(tabBtn)
		local tp: UIPadding = Instance.new("UIPadding")
		tp.PaddingLeft = UDim.new(0, 10)
		tp.Parent      = tabBtn

		local content: Frame = Instance.new("Frame")
		content.Size                  = UDim2.new(1, 0, 0, 0)
		content.BackgroundTransparency = 1
		content.ClipsDescendants      = true
		content.LayoutOrder           = nxt()
		content.Parent                = scroll

		local cLayout: UIListLayout = Instance.new("UIListLayout")
		cLayout.Padding   = UDim.new(0, 4)
		cLayout.SortOrder = Enum.SortOrder.LayoutOrder
		cLayout.Parent    = content

		local cPad: UIPadding = Instance.new("UIPadding")
		cPad.PaddingLeft   = UDim.new(0, 8)
		cPad.PaddingRight  = UDim.new(0, 0)
		cPad.PaddingBottom = UDim.new(0, 4)
		cPad.Parent        = content

		local folderOpen: boolean = false
		local function updateFolder()
			task.defer(function()
				if folderOpen then
					local h = cLayout.AbsoluteContentSize.Y + 8
					TweenService:Create(content, TweenInfo.new(0.25), { Size = UDim2.new(1, 0, 0, h) }):Play()
				else
					for _, obj in ipairs(content:GetDescendants()) do
						if obj:IsA("Frame") and obj.ClipsDescendants and obj ~= content then
							(obj :: Frame).Size = UDim2.new(1, 0, 0, 0)
						end
					end
					TweenService:Create(content, TweenInfo.new(0.25), { Size = UDim2.new(1, 0, 0, 0) }):Play()
				end
				task.wait(0.26)
				updateCanvas()
			end)
		end

		tabBtn.MouseButton1Click:Connect(function()
			folderOpen = not folderOpen
			tabBtn.Text      = (folderOpen and "▼  " or "▶  ") .. (folderName or "Folder")
			tabBtn.TextColor3 = folderOpen and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(180, 180, 180)
			updateFolder()
		end)

		local Folder    = {}
		local _fOrder: number = 0
		local function fnxt(): number _fOrder += 1; return _fOrder end

		function Folder:Button(text: string, callback: () -> ())
			local btn: TextButton = Instance.new("TextButton")
			btn.Size             = UDim2.new(1, 0, 0, 36)
			btn.Text             = text or "Button"
			btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			btn.TextColor3       = Color3.fromRGB(255, 255, 255)
			btn.Font             = Enum.Font.GothamBold
			btn.TextSize         = 14
			btn.LayoutOrder      = fnxt()
			btn.TextXAlignment   = Enum.TextXAlignment.Left
			btn.Parent           = content
			_style(btn)
			local bp: UIPadding = Instance.new("UIPadding")
			bp.PaddingLeft  = UDim.new(0, 10)
			bp.PaddingRight = UDim.new(0, 30)
			bp.Parent       = btn
			local arr: ImageLabel = Instance.new("ImageLabel")
			arr.Size               = UDim2.new(0, 16, 0, 16)
			arr.AnchorPoint        = Vector2.new(1, 0.5)
			arr.Position           = UDim2.new(1, 12, 0.5, 0)
			arr.ZIndex             = btn.ZIndex + 1
			arr.BackgroundTransparency = 1
			arr.Image              = "rbxthumb://type=Asset&id=13306021335&w=420&h=420"
			arr.ImageColor3        = Color3.fromRGB(200, 200, 200)
			arr.Parent             = btn
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0), { BackgroundColor3 = Color3.fromRGB(220, 20, 60) }):Play()
				task.wait(0)
				TweenService:Create(btn, TweenInfo.new(0), { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }):Play()
				if callback then pcall(callback) end
			end)
			updateCanvas()
			return btn
		end

		function Folder:Toggle(text: string, default: boolean, callback: (boolean) -> ())
			local state: boolean = default or false
			local row: TextButton = Instance.new("TextButton")
			row.Size             = UDim2.new(1, 0, 0, 36)
			row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			row.Text             = ""
			row.LayoutOrder      = fnxt()
			row.Parent           = content
			_style(row)
			local lbl: TextLabel = Instance.new("TextLabel")
			lbl.Size               = UDim2.new(1, -50, 1, 0)
			lbl.Position           = UDim2.new(0, 10, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text               = text or "Toggle"
			lbl.Font               = Enum.Font.GothamBold
			lbl.TextSize           = 14
			lbl.TextColor3         = Color3.new(1, 1, 1)
			lbl.TextXAlignment     = Enum.TextXAlignment.Left
			lbl.Parent             = row
			local box: Frame = Instance.new("Frame")
			box.Size             = UDim2.new(0, 22, 0, 22)
			box.Position         = UDim2.new(1, -32, 0.5, -11)
			box.BackgroundColor3 = state and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 40, 40)
			box.Parent           = row
			Instance.new("UICorner", box)
			row.MouseButton1Click:Connect(function()
				state = not state
				box.BackgroundColor3 = state and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 40, 40)
				if callback then pcall(callback, state) end
			end)
			updateCanvas()
			local T = {}
			function T:Set(v: boolean)
				state = v
				box.BackgroundColor3 = v and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(40, 40, 40)
			end
			function T:Get(): boolean return state end
			return T
		end

		function Folder:Slider(text: string, min: number, max: number, default: number, callback: (number) -> ())
			min = min or 0; max = max or 100
			local val: number = math.clamp(default or min, min, max)
			local cont: Frame = Instance.new("Frame")
			cont.Size             = UDim2.new(1, 0, 0, 65)
			cont.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			cont.LayoutOrder      = fnxt()
			cont.Parent           = content
			_style(cont)
			local tLbl: TextLabel = Instance.new("TextLabel")
			tLbl.Size               = UDim2.new(0.6, 0, 0, 20)
			tLbl.Position           = UDim2.new(0, 10, 0, 5)
			tLbl.Text               = text or "Slider"
			tLbl.Font               = Enum.Font.GothamBold
			tLbl.TextSize           = 14
			tLbl.TextXAlignment     = Enum.TextXAlignment.Left
			tLbl.TextColor3         = Color3.new(1, 1, 1)
			tLbl.BackgroundTransparency = 1
			tLbl.Parent             = tLbl
			tLbl.Parent             = cont
			local numBox: Frame = Instance.new("Frame")
			numBox.Size             = UDim2.new(0.15, 0, 0, 22)
			numBox.Position         = UDim2.new(0.85, 0, 0, 5)
			numBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			numBox.BorderSizePixel  = 0
			numBox.Parent           = cont
			Instance.new("UICorner", numBox)
			local valTxt: TextBox = Instance.new("TextBox")
			valTxt.Size               = UDim2.new(1, 0, 1, 0)
			valTxt.BackgroundTransparency = 1
			valTxt.Text               = tostring(val)
			valTxt.Font               = Enum.Font.GothamBold
			valTxt.TextSize           = 13
			valTxt.TextColor3         = Color3.fromRGB(200, 200, 200)
			valTxt.ClearTextOnFocus   = false
			valTxt.TextXAlignment     = Enum.TextXAlignment.Center
			valTxt.TextYAlignment     = Enum.TextYAlignment.Center
			valTxt.Parent             = numBox
			local bar: Frame = Instance.new("Frame")
			bar.Size             = UDim2.new(0.95, -10, 0, 8)
			bar.Position         = UDim2.new(0, 10, 0.62, 0)
			bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			bar.Parent           = cont
			Instance.new("UICorner", bar)
			local ip: number = (val - min) / (max - min)
			local fill: Frame = Instance.new("Frame")
			fill.Size             = UDim2.new(ip, 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
			fill.Parent           = bar
			Instance.new("UICorner", fill)
			local knob: Frame = Instance.new("Frame")
			knob.Size             = UDim2.new(0, 14, 0, 14)
			knob.AnchorPoint      = Vector2.new(0.5, 0.5)
			knob.Position         = UDim2.new(ip, 0, 0.5, 0)
			knob.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
			knob.Parent           = bar
			Instance.new("UICorner", knob)
			local sliderDrag: boolean = false
			local function setPos(pos: number)
				pos       = math.clamp(pos, 0, 1)
				fill.Size     = UDim2.new(pos, 0, 1, 0)
				knob.Position = UDim2.new(pos, 0, 0.5, 0)
				val           = math.floor(min + pos * (max - min))
				valTxt.Text   = tostring(val)
				if callback then pcall(callback, val) end
			end
			bar.InputBegan:Connect(function(i: InputObject)
				if i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					sliderDrag = true
					setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
				end
			end)
			UIS.InputChanged:Connect(function(i: InputObject)
				if sliderDrag and (i.UserInputType == Enum.UserInputType.MouseMovement
					or i.UserInputType == Enum.UserInputType.Touch)
				then
					setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
				end
			end)
			UIS.InputEnded:Connect(function(i: InputObject)
				if i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					sliderDrag = false
				end
			end)
			valTxt.FocusLost:Connect(function(enter: boolean)
				if enter then
					local v = tonumber(valTxt.Text)
					if v then
						val = math.clamp(v, min, max)
						local p = (val - min) / (max - min)
						fill.Size     = UDim2.new(p, 0, 1, 0)
						knob.Position = UDim2.new(p, 0, 0.5, 0)
						valTxt.Text   = tostring(val)
						if callback then pcall(callback, val) end
					else
						valTxt.Text = tostring(val)
					end
				end
			end)
			updateCanvas()
			local S = {}
			function S:Set(v: number)
				val = math.clamp(v, min, max)
				local p = (val - min) / (max - min)
				fill.Size     = UDim2.new(p, 0, 1, 0)
				knob.Position = UDim2.new(p, 0, 0.5, 0)
				valTxt.Text   = tostring(val)
			end
			function S:Get(): number return val end
			return S
		end

		function Folder:Dropdown(headerText: string, options: {string}, callback: (string) -> ())
			local selected: string = "Select Option"
			local dropBtn: TextButton = Instance.new("TextButton")
			dropBtn.Size             = UDim2.new(1, 0, 0, 46)
			dropBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			dropBtn.Text             = ""
			dropBtn.LayoutOrder      = fnxt()
			dropBtn.Parent           = content
			_style(dropBtn)
			local headLbl: TextLabel = Instance.new("TextLabel")
			headLbl.Size               = UDim2.new(1, -10, 0, 16)
			headLbl.Position           = UDim2.new(0, 5, 0, 2)
			headLbl.BackgroundTransparency = 1
			headLbl.Text               = headerText or "Dropdown"
			headLbl.TextColor3         = Color3.fromRGB(170, 170, 170)
			headLbl.Font               = Enum.Font.Gotham
			headLbl.TextSize           = 12
			headLbl.TextXAlignment     = Enum.TextXAlignment.Left
			headLbl.Parent             = dropBtn
			local selLbl: TextLabel = Instance.new("TextLabel")
			selLbl.Size               = UDim2.new(1, -25, 1.3, 0)
			selLbl.Position           = UDim2.new(0, 5, 0, 0)
			selLbl.BackgroundTransparency = 1
			selLbl.Text               = selected
			selLbl.TextColor3         = Color3.new(1, 1, 1)
			selLbl.Font               = Enum.Font.GothamBold
			selLbl.TextSize           = 14
			selLbl.TextXAlignment     = Enum.TextXAlignment.Left
			selLbl.Parent             = dropBtn
			local arrowLbl: TextLabel = Instance.new("TextLabel")
			arrowLbl.Size               = UDim2.new(0, 20, 1, 0)
			arrowLbl.Position           = UDim2.new(1, -20, 0, 0)
			arrowLbl.BackgroundTransparency = 1
			arrowLbl.Text               = "▼"
			arrowLbl.TextColor3         = Color3.fromRGB(200, 200, 200)
			arrowLbl.Font               = Enum.Font.GothamBold
			arrowLbl.TextSize           = 18
			arrowLbl.TextXAlignment     = Enum.TextXAlignment.Center
			arrowLbl.Parent             = dropBtn
			local dropFrame: Frame = Instance.new("Frame")
			dropFrame.Size             = UDim2.new(1, 0, 0, 0)
			dropFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			dropFrame.ClipsDescendants = true
			dropFrame.LayoutOrder      = fnxt()
			dropFrame.Parent           = content
			Instance.new("UICorner", dropFrame)
			Instance.new("UIListLayout", dropFrame)
			local open: boolean = false
			for _, v in ipairs(options or {}) do
				local opt: TextButton = Instance.new("TextButton")
				opt.Size             = UDim2.new(1, 0, 0, 28)
				opt.Text             = v
				opt.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				opt.TextColor3       = Color3.new(1, 1, 1)
				opt.Font             = Enum.Font.GothamBold
				opt.TextSize         = 13
				opt.Parent           = dropFrame
				_style(opt)
				opt.MouseButton1Click:Connect(function()
					selected    = v
					selLbl.Text = v
					open        = false
					TweenService:Create(dropFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 0) }):Play()
					task.wait(0.21)
					updateFolder()
					updateCanvas()
					if callback then pcall(callback, v) end
				end)
			end
			dropBtn.MouseButton1Click:Connect(function()
				open = not open
				local h: number = open and (#options * 28) or 0
				TweenService:Create(dropFrame, TweenInfo.new(0.25), { Size = UDim2.new(1, 0, 0, h) }):Play()
				task.delay(0.26, function()
					updateFolder()
					updateCanvas()
				end)
			end)
			updateCanvas()
			local D = {}
			function D:Get(): string return selected end
			function D:Set(v: string) selected = v; selLbl.Text = v end
			return D
		end

		return Folder
	end

	updateCanvas()
	return Win
end

-- START
function Lib:Start()
	_loaded = true
	for _, fn in ipairs(_pendingShow) do fn() end
	_pendingShow = {}
	_reposition()
end

return Lib
