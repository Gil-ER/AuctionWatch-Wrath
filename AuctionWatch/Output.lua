-- Edited Jun 19, 2023

local addon, aw = ...;
local t = {};		
local list = {};	
aw.button = {};		
local currentIndex = 1;
local ScrollChild;
function aw:colorString(c, str)
	local color = 	{ ["red"] = "FF0000", ["green"]  = "00FF00" }
	if str == nil then str = "nil"; end;
	return string.format("|cff%s%s|r", color[c], str);
end
function aw:myPrint( ... )
    local prefix = string.format("|cff%s%s|r", "0088EE", "Auction Watch: ");	
	local message = string.join(" ", ...);
	print(prefix,  message);
end
local CreateStringTable = function ()
	for i = 1, 20 do
		local row = -20 * (i - 1);		
		t[i] = {	[1] = ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal"), 
					[2] = ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
					[3] = ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
					[4] = ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
					[5] = ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			};
		t[i][1]:SetPoint("TOPLEFT", 15, row);
		t[i][1]:SetWidth(35);
		t[i][1]:SetJustifyH("RIGHT");
		t[i][2]:SetPoint("TOPLEFT", t[i][1], "TOPRIGHT", 10, 0);	
		t[i][2]:SetWidth(190);
		t[i][2]:SetJustifyH("LEFT");
		t[i][3]:SetPoint("TOPLEFT", t[i][2], "TOPRIGHT", 0, 0);
		t[i][3]:SetWidth(55);
		t[i][3]:SetJustifyH("LEFT");
		t[i][4]:SetPoint("TOPLEFT", t[i][3], "TOPRIGHT", 0, 0);
		t[i][4]:SetWidth(30);
		t[i][4]:SetJustifyH("RIGHT");		
		t[i][5]:SetPoint("TOPLEFT", t[i][4], "TOPRIGHT", 0, 0);
		t[i][5]:SetWidth(40);
		t[i][5]:SetJustifyH("LEFT");		
	end;
	t[21] = { [1] = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal") };
	t[21][1]:SetPoint("TOPLEFT", 15, -15 * 23);
	t[21][1]:SetText("/aw or /auctionwatch to show this report.");
end 
function aw:ClearAllText()
	for i = 1, 20 do		
		for j = 1, 5 do		
			t[i][j]:SetText("");
		end
	end
end
aw.auctions = {};
function aw.auctions:Clear()
	list = {};
end
function aw.auctions:AddLine(col1, col2, col3, col4, col5)
	local idx = #list + 1
	list[idx] = { [1] = col1; [2] = col2; [3] = col3; [4] = col4; [5] = col5 };	
end
function aw.auctions:Show(idx)
	if idx == nil then idx = 1; end;
	if #list < 1 then return; end;
	aw:ClearAllText();
	if idx > #list then idx = #list; end;
	for row = 0, 19 do
		t[row + 1][1]:SetText(list[idx + row][1]);
		t[row + 1][2]:SetText(list[idx + row][2]);
		t[row + 1][3]:SetText(list[idx + row][3]);
		t[row + 1][4]:SetText(list[idx + row][4] .. ":");
		t[row + 1][5]:SetText(list[idx + row][5]);
		if idx + row == #list then return; end;
	end
end
function aw:GetListedToon(idx)
	return t[idx][2]:GetText()
end
local params = {
	title = "Auction Watch",
	name = "AuctionWatchReportFrame",
	anchor = "CENTER",
	parent = UIParent,
	relFrame = UIParent,
	relPoint = "CENTER",
	xOff = 0,
	yOff = 0,
	width = 400,
	height = 400,
	isMovable = true
}
aw.Output = aw:createFrame(params);						
aw.ScrollFrame = CreateFrame("ScrollFrame", nil, aw.Output, "UIPanelScrollFrameTemplate");
aw.ScrollFrame:ClearAllPoints();
aw.ScrollFrame:SetPoint("TOPLEFT", aw.Output, "TOPLEFT", 12, -70);
aw.ScrollFrame:SetPoint("BOTTOMRIGHT", aw.Output, "BOTTOMRIGHT", -10, 60);
aw.ScrollFrame:SetClipsChildren(true);
aw.ScrollFrame.ScrollBar:ClearAllPoints();
aw.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", aw.ScrollFrame, "TOPRIGHT", -12, -18);
aw.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", aw.ScrollFrame, "BOTTOMRIGHT", -7, 18);
ScrollChild = CreateFrame("Frame");
aw.ScrollFrame:SetScrollChild(ScrollChild);
ScrollChild:SetSize(aw.ScrollFrame:GetWidth() - 18, ( aw.ScrollFrame:GetHeight() * 2 ));
CreateStringTable();									
local w = (params.width -20) / 3;
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.Output,
	relFrame = aw.Output,
	relPoint = "BOTTOMRIGHT",
	xOff = -10,
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Swap Sort",
	ttip = "Swap the field being sorted\nNumber of auctions/time since last visit.",
	pressFunc = function (self) aw:ReportAuctionsToWindow(true); end;
}
aw:createButton(params);
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.Output,
	relFrame = aw.Output,
	relPoint = "BOTTOMRIGHT",
	xOff = -10 - w,
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Remove Toon",
	ttip = "Swap the field being sorted\nNumber of auctions/time since last visit.",
	pressFunc = function (self) aw:RemoveToon(); end;
}
aw:createButton(params);
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.Output,
	relFrame = aw.Output,
	relPoint = "BOTTOMRIGHT",
	xOff = -10 - (2 * w),
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Open Config.",
	ttip = "Swap the field being sorted\nNumber of auctions/time since last visit.",
	pressFunc = function (self) InterfaceOptionsFrame_OpenToCategory(aw.panel);
								InterfaceOptionsFrame_OpenToCategory(aw.panel); end;
}
aw:createButton(params);
_G[aw.Output:GetName() .. "Portrait"]:SetTexture("Interface\\AddOns\\AuctionWatch\\AW_Button.blp");		
local colHeader = aw.Output:CreateFontString( nil, "OVERLAY", "GameFontNormal");
colHeader:SetPoint("TOPRIGHT",aw.Output, "TOPRIGHT", -5, -35);
colHeader:SetJustifyH("LEFT");
colHeader:SetText("Time Since Last Visit\nto the Auction House");
aw.Output:Hide();
