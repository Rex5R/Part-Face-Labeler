local toolbar = plugin:CreateToolbar("Part Face Labeler")

local rad = math.rad

local Enabled = false

local pluginBtn = toolbar:CreateButton(
	"Display Part Faces and Pivot",
	"Display Part Faces and Pivot",
	0
)

function tableToVector(str : string, i) return Vector3.new(table.unpack(string.split(str[i],","))) end

function destroyGuiModel(Selection) : Selection
	if Selection ~= nil then
		for _, i in pairs(Selection:GetDescendants()) do
			if i:IsA("BillboardGui") and i["_"] or i:IsA("LineHandleAdornment") then
				i:Destroy()
			end
		end
	end
end

pluginBtn.Click:Connect(function()
	local Select = game:GetService("Selection")
	local Selection = Select:Get()[1]
	
	local function createBillBoardGui(Obj : BasePart)
		local worldOffsetCodes = {
			"0,1.2,0", -- Top
			"0,-1.2,0", -- Bottom
			"1.2,0,0", -- Right
			"-1.2,0,0", -- Left
			"0,0,1.2", -- Back
			"0,0,-1.2" -- Front
		}
		
		local colorOffsetCodes = {
			Color3.new(0,1,0),
			Color3.new(0,1,0),
			Color3.new(1,0,0),
			Color3.new(1,0,0),
			Color3.new(0,0,1),			
			Color3.new(0,0,1)
		}
		
		local textOffsets = {"Top","Bottom","Right","Left","Back","Front"}
		
		for i = 1, 6 do
			local BillBoardGui = Instance.new("BillboardGui", Obj)
			BillBoardGui.Size = UDim2.new(2,0,2,0)
			BillBoardGui.ExtentsOffsetWorldSpace = tableToVector(worldOffsetCodes, i)
			BillBoardGui.Name = `{textOffsets[i]}_`
			
			local TextLabel = Instance.new("TextLabel", BillBoardGui)
			TextLabel.Size = UDim2.new(1,0,1,0)
			TextLabel.Text = textOffsets[i]
			TextLabel.TextScaled = true
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextColor3 = Color3.new(1,1,1)
			TextLabel.Name = '_'
			
			local Cylinder = Instance.new("LineHandleAdornment", Obj)
			Cylinder.Thickness = 1
			Cylinder.Adornee = Obj
			Cylinder.AlwaysOnTop = true
			Cylinder.Color3 = colorOffsetCodes[i]
			
			Cylinder.CFrame = Obj.CFrame + tableToVector(worldOffsetCodes, i)
			Cylinder.CFrame = CFrame.lookAt(Cylinder.CFrame.Position, Obj.Position)
			Cylinder.CFrame = CFrame.new(Vector3.new(0,0,0)) * CFrame.Angles(Cylinder.CFrame:ToEulerAnglesXYZ())
		end
	end
	
	if not Enabled then
		if Selection ~= nil then
			createBillBoardGui(Selection)
		else
			warn("No Object Selected")
		end
	else destroyGuiModel(Selection) end
	
	Enabled = not Enabled
end)
