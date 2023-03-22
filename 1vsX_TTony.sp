#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

int		trid = 0;
int	    ctid = 0;
bool    ctp = false;
bool    trp = false;
bool	CSGO;
bool    ctannounce = false;
bool    trannounce = false;
bool    roundend = false;

public Plugin myinfo =
{
    name = "Defean Alone Players",
    author = "TTony",
    description = "Defeans players if they are left alone in a team",
    version = "0.0.1",
    url = "https://github.com/PrdTTony"
};

public void OnPluginStart()
{
    HookEvent("player_death", Event_PlayerDeath);
    HookEvent("round_start", Event_RoundStart);
    HookEvent("round_end", Event_RoundEnd);
    CSGO   = GetEngineVersion() == Engine_CSGO;
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    
    if (CSGO && GameRules_GetProp("m_bWarmupPeriod") == 1)
		return Plugin_Continue;
    
    if(roundend == true) 
        return Plugin_Continue;

	if (trs_alive() == 1)
	{
        SetIDs();
        
        
        for (int i = 1; i <= MaxClients; i++)
        {      
            if(IsValidClient(i))
                SetListenOverride(trid, i, Listen_No);  
        }   

        trp = true;

        if (trannounce == false)
        {
            PrintToChatAll(" \x04[ClutchTime] \x01Player \x06%N \x01can no longer hear others!", trid);
            trannounce = true;  
        }
        
	}

	if (cts_alive() == 1)
	{   
        
        SetIDs();
        
        
        for (int i = 1; i <= MaxClients; i++)
        {
            if(IsValidClient(i))
                SetListenOverride(ctid, i, Listen_No);       
        }  

        ctp = true;

        if (ctannounce == false)
        {
            PrintToChatAll(" \x04[ClutchTime] \x01Player \x06%N \x01can no longer hear others!", ctid);
            ctannounce = true;
        }      
         
	}   

    return Plugin_Continue;
}


public void Event_RoundStart(Event event, const char[] name, bool bDb)
{
    ctid = 0, trid = 0;
    trannounce = false;
    ctannounce = false;
    roundend = false;
    
}

public Action Event_RoundEnd(Event event, const char[] name, bool bDb)
{
    roundend = true;

    if(trp == true){
        for(int i = 1; i <= MAXPLAYERS; i++)
        {
            if (IsValidClient(i) && IsValidClient(trid))
            {
                SetListenOverride(trid, i, Listen_Default);
            }
        }  
        trp = false;  
    }  

    if(ctp == true){
        for(int i = 1; i <= MAXPLAYERS; i++)
        {
            if (IsValidClient(i) && IsValidClient(ctid))
            {
                SetListenOverride(ctid, i, Listen_Default);
            }
        }
        ctp = false;
    }

    ctid = 0, trid = 0;
}

public int trs_alive()
{
	int g_TRs = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
		{
			g_TRs++;
          
		}
	}
	return g_TRs;
}

public int cts_alive()
{
	int g_CTs = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 3)
		{
			g_CTs++;
            
		}
	}
	return g_CTs;
}

stock bool IsValidClient(int client)
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	if (!IsClientConnected(client)) return false;
	return IsClientInGame(client);
}

void SetIDs()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i))
		{
			if (GetClientTeam(i) == 2)
			{
				trid = i;
			}
			else if (GetClientTeam(i) == 3)
			{
				ctid = i;
			}
		}
	}
}