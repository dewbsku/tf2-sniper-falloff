#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#pragma newdecls required
#pragma semicolon 1


Handle enabled = 				INVALID_HANDLE;
Handle distance_min =			INVALID_HANDLE;
Handle distance_max = 			INVALID_HANDLE;
Handle fraction = 				INVALID_HANDLE;
Handle headshotoverride = 		INVALID_HANDLE;
Handle distance_min_headshot =	INVALID_HANDLE;
Handle distance_max_headshot =	INVALID_HANDLE;
Handle fraction_headshot = 		INVALID_HANDLE;



public Plugin myinfo =
{
	name = "Sniper Falloff",
	author = "Dooby Skoo",
	description = "Configurable sniper fall off values",
	version = "1.0",
	url = "https://github.com//dewbsku"
};


public void OnPluginStart()
{
	enabled = CreateConVar("sm_sniperfalloff_enabled", "0", "Master switch of the plugin", FCVAR_NONE,  true, 0.0, true, 1.0);
	distance_min = CreateConVar("sm_sniperfalloff_distance_min", "0", "Distance at which falloff will take effect", FCVAR_NONE, true, 0.0);
	distance_max = CreateConVar("sm_sniperfalloff_distance_max", "0", "Distance at which falloff will max out", FCVAR_NONE, true, 0.0);
	fraction = CreateConVar("sm_sniperfalloff_fraction", "1", "Fraction of normal damage player deals at full falloff", FCVAR_NONE, true, 0.0, true, 1.0);
	headshotoverride = CreateConVar("sm_sniperfalloff_headshotoverride", "0", "Dictates whether headshots follow different falloff values", FCVAR_NONE, true, 0.0, true, 1.0);
	distance_min_headshot = CreateConVar("sm_sniperfalloff_distance_min_headshot", "0", "Distance at which headshot falloff will take effect (sm_sniperfalloff_headshotoverride must be set to 1)", FCVAR_NONE, true, 0.0);
	distance_max_headshot = CreateConVar("sm_sniperfalloff_distance_max_headshot", "0", "Distance at which headshot falloff will max out (sm_sniperfalloff_headshotoverride must be set to 1)", FCVAR_NONE, true, 0.0);
	fraction_headshot = CreateConVar("sm_sniperfalloff_fraction_headshot", "1", "Fraction of normal headshot damage player deals at full falloff (sm_sniperfalloff_headshotoverride must be set to 1)", FCVAR_NONE, true, 0.0, true, 1.0);
}

public void OnClientPutInServer( int client ) {
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3]){
	if(!IsValidClient(victim) || !IsValidClient(inflictor)) return Plugin_Continue;
	float fDistance = getPlayerDistance(attacker, victim);
	
	if(GetConVarBool(enabled) == false) return Plugin_Continue;
	char weapon_classname[64];
	GetEntityClassname( weapon, weapon_classname, sizeof weapon_classname );
	float fdistance_min = GetConVarFloat(distance_min);		
	float fdistance_max = GetConVarFloat(distance_max);	
	float ffraction = GetConVarFloat(fraction);				
	bool bheadshotoverride = GetConVarBool(headshotoverride);
	float fdistance_min_headshot = GetConVarFloat(distance_min_headshot);	
	float fdistance_max_headshot = GetConVarFloat(distance_max_headshot);	
	float ffraction_headshot = GetConVarFloat(fraction_headshot);
	
	

	if(bheadshotoverride && damagetype & DMG_CRIT){
		fdistance_min = fdistance_min_headshot;
		fdistance_max = fdistance_max_headshot;
		ffraction = ffraction_headshot;
	}

	if(StrEqual(weapon_classname, "tf_weapon_sniperrifle")){
		if(fDistance<=fdistance_min) return Plugin_Continue;
		if(fDistance>=fdistance_max){
			damage = ffraction*damage;
			return Plugin_Changed;
		}
		damage = (damage * ( ( (-1*fDistance * (1-ffraction) )  +   (fdistance_min*(1-ffraction))) / (fdistance_max - fdistance_min))) + damage; //yes
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

float getPlayerDistance(int player1, int player2){
	float a[3];
	float b[3];
	GetClientEyePosition(player1, a);
	GetClientEyePosition(player2, b);
	return SquareRoot((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) + (a[2] - b[2]) * (a[2] - b[2]));
}

bool IsValidClient(int client) {
	return ( client > 0 && client <= MaxClients && IsClientInGame(client) );
}