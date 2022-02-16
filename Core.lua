CEPGP_DT = {
    Enabled = true,
    WrongCEPGPVersion = false,
    RequiredCEPGPVersion = "1.14.0",
    Roster =  {},
    DBConvert = 0
};

CEPGP_DT_Info = {
    Version = "1.0.0"
}

CDT_OriginalFunction = nil;

function CDT_OnEvent(event, ...)

    if event == "ADDON_LOADED" then
		local args = {unpack({...})};
		if args[1] == "CEPGP_DetailedTraffic" then
			CDT_init();
		end
    end
    
    -- if event == "GUILD_ROSTER_UPDATE" and CEPGP_ST.Enabled then
    --     CST_UpdateRoster();
    -- end
end

function CDT_init()
    if CEPGP_DT.Enabled then
        CDT_VersionCheck();
    end
    if CEPGP_DT.Enabled and not CEPGP_DT.WrongCEPGPVersion then
        CDT_ListButton_OnClick_hook();
    end
    CEPGP_addPlugin("CEPGP_DetailedTraffic", nil, CEPGP_DT.Enabled, CDT_toggle);
    -- if not CEPGP_ST.DBConvert then
    --     print("CEPGP Standings Tracker: Starting database conversion.");
    --     CST_DBConvert();
    --     print("CEPGP Standings Tracker: Database conversion complete.");
    --     CEPGP_ST.DBConvert = 1;
    -- end
end

function CDT_VersionCheck()
    local args
    if CEPGP_Info.Version["Number"] then
        args = CEPGP_split(CEPGP_Info.Version["Number"], ".");
    else
        args = CEPGP_split(CEPGP_Info.Version, ".");
    end
    local major = tonumber(args[1]);
	local minor = tonumber(args[2]);
    local revision = tonumber(args[3]);
    if major == 1 and minor <= 14 then
        CEPGP_DT.WrongCEPGPVersion = true;
        DEFAULT_CHAT_FRAME:AddMessage("|c006969FFCEPGP Standings Tracker: Your installed version of CEPGP is not supported, please update to version 1.14.0 or higher.|r");
    end    
end

function CDT_toggle()
    if CEPGP_DT.Enabled then
        CEPGP_DT.Enabled = false;
        if not CEPGP_DT.WrongCEPGPVersion then
            CEPGP_UpdateGuildScrollBar = CDT_OriginalFunction;
        end
    else  
        CEPGP_DT.Enabled = true;
        if not CEPGP_DT.WrongCEPGPVersion then
            CEPGP_UpdateGuildScrollBar_hook();
        else
            CDT_VersionCheck();
        end
    end
end

