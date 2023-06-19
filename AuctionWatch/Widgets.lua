-- Edited Jun 19, 2023

local addon, aw = ...;
local frameCount = 0;
function aw:createCheckBox(opts)	
	frameCount = frameCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedCheckboxNumber" .. frameCount;
	end;
	local cb = CreateFrame("CheckButton", opts.name, opts.parent, "ChatConfigCheckButtonTemplate");
	cb:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	cb:SetSize(32, 32);	
	local txt = opts.parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
	txt:SetPoint("BOTTOMLEFT", cb, "BOTTOMRIGHT", 5, 10);
	txt:SetText(opts.caption);	
	cb.tooltip = opts.ttip;	
	return cb, txt;
end
local buttonCount = 0;
function aw:createButton(opts)
	buttonCount = buttonCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedButtonNumber" .. buttonCount;
	end;	
	local btn = CreateFrame("Button",  opts.name, opts.parent, "GameMenuButtonTemplate");
	btn:SetSize(opts.width, opts.height);
	btn:SetText(opts.caption);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	btn:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	if (opts.ttip ~= nil) or (opts.ttip ~= "") then 
		btn:SetScript("OnEnter", function()
			GameTooltip:SetOwner(btn, "LEFT");
			GameTooltip:AddLine(opts.ttip);
			GameTooltip:Show();
		end);
		btn:SetScript("OnLeave", function() GameTooltip:Hide(); end);
	end;
	if opts.pressFunc ~= nil then 
		btn:SetScript("OnClick", function(self, button, down)
			opts.pressFunc(self, button)
		end)
	end;
	return b;	
end;
local frameCount = 0;
function aw:createFrame(opts)
	frameCount = frameCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedFrameNumber" .. frameCount;
	end;
	local f = CreateFrame("Frame", opts.name, opts.parent, "ButtonFrameTemplate");
	f:SetSize(opts.width, opts.height);
	f:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts,yOff);
	if opts.title ~= nil then
		_G[f:GetName() .. "TitleText"]:SetText( opts.title );
	end;
	if opts.isMovable then
		f:EnableMouse(true);
		f:SetMovable(true);
		f:SetUserPlaced(true); 
		f:RegisterForDrag("LeftButton");
		f:SetScript("OnDragStart", function(self) self:StartMoving() end);
		f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
	end;
	if opts.isResizable then
		f:SetResizable(true);
		f:SetScript("OnMouseDown", function()
			f:StartSizing("BOTTOMRIGHT")
		end);
		f:SetScript("OnMouseUp", function()
			f:StopMovingOrSizing()
		end);
		f:SetScript("OnSizeChanged", OnSizeChanged);
	end;
	return f;		
end;
local sliderCount = 0;
function aw:createSlider(opts)
	sliderCount = sliderCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedSliderNumber" .. sliderCount;
	end
	local slide = CreateFrame("Slider", opts.name, opts.parent, "OptionsSliderTemplate");	
	slide:SetOrientation(opts.orientation);
	slide:SetPoint ("TOPRIGHT", opts.relFrame, "TOPRIGHT", opts.xOff, opts.yOff); 
	slide:SetWidth(opts.width);
	slide:SetHeight(opts.height);	
	getglobal(opts.name .. "Low"):SetText(opts.min);
	getglobal(opts.name .. "High"):SetText(opts.max);	
	if opts.min ~= "" and opts.max ~= "" then slide:SetMinMaxValues(opts.min, opts.max) end;
	slide:SetValueStep(opts.step)
	return slide;
end
