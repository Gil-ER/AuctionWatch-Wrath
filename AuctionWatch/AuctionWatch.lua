--aw namespace variable
local _, aw = ...;

aw.ID = GetUnitName("player") .. "-" .. GetRealmName();
aw.auctionCount = 0;

SLASH_AUCTIONWATCH1 = "/auctionwatch";
SLASH_AUCTIONWATCH2 = "/aw";
SlashCmdList.AUCTIONWATCH = function(msg)
	aw:ReportAuctionsToWindow();
end

-- **********************************************************************
-- Event Frame
-- **********************************************************************
local frame = CreateFrame("FRAME");
frame:RegisterEvent("SPELLS_CHANGED");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("AUCTION_HOUSE_CLOSED");
frame:RegisterEvent("AUCTION_OWNED_LIST_UPDATE");

function frame:OnEvent(event, arg1, arg2)
	if event == "SPELLS_CHANGED" then
	--Play Raid Warning if there are really old auctions
		if aw:VeryOldAuctions() then
			PlaySound(SOUNDKIT.RAID_WARNING);
			aw:myPrint(aw:colorString("red", "*******************************************") );
			aw:myPrint(aw:colorString("red", "   YOU HAVE VERY OLD AUCTIONS") );
			aw:myPrint(aw:colorString("red", "*******************************************") );
		end;
		tinsert(UISpecialFrames, "AuctionWatchReportFrame");	--Close with ESC key
		frame:UnregisterEvent("SPELLS_CHANGED");				--Only run once
	end;
	
	if event == "PLAYER_LOGIN" then 
		aw.auctionCount = aw:GetCount(aw.ID);
		--Single line report on login
		if aw:ExpiredAuctions() then 
			aw:myPrint(aw:colorString("red", "You have toons with auctions that need attention.") ); 	
		else
			aw:myPrint(aw:colorString("green", "No toons with auctions that need attention.") ); 	
		end;
		--Report to Window
		if aw:GetSetting("Window") then 
			if aw:GetSetting("WinOnlyOver") then
				if  aw:ExpiredAuctions() then aw:ReportAuctionsToWindow(); end;
			else
				print("always report")
				aw:ReportAuctionsToWindow(); 
			end;
		end;
		--Report to chat
		if aw:GetSetting("Chat") then aw:ReportAuctionsToChat(); end;		
		aw:LoadOptions();
	end 
	
	if event == "AUCTION_OWNED_LIST_UPDATE" then
		_,aw.auctionCount = GetNumAuctionItems("owner");
	end
	
	if event == "AUCTION_HOUSE_CLOSED" then
		if aw.auctionCount > 0 then	aw:UpdateToon(aw.ID); else aw:RemoveToonFromDB(aw.ID); end;
	end
end	
frame:SetScript("OnEvent", frame.OnEvent);


	
