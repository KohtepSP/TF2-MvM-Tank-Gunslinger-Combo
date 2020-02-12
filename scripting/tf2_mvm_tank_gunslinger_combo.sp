#pragma semicolon 1

#include <sourcemod>

public Plugin myinfo = 
{
	name = "[TF2] MvM Tank Gunslinger Combo",
	author = "2010kohtep",
	description = "Enable gunslinger 3-punch combo functionality on tank",
	version = "1.0.0",
	url = "https://github.com/2010kohtep"
};

public void OnPluginStart()
{
	Handle hConf = LoadGameConfigFile("tf2.koh.tankgunslingercombo");
	if (hConf == null)
		SetFailState("[ERROR] Can't find tf2.koh.tankgunslingercombo gamedata.");
	
	Address pAddr = GameConfGetAddressEx(hConf, "Patch_CTFRobotArm_Smack", "CTFRobotArm::Smack");
	if (pAddr == Address_Null)
		SetFailState("[ERROR] Failed to patch CTFRobotArm::Smack.");
	
	WriteData(pAddr, {0x90, 0x90}, 2);
}

stock void WriteData(Address pAddr, int[] Data, int iSize)
{
	if (pAddr == Address_Null)
		return;
	
	for (int i = 0; i < iSize; i++)
	{
		StoreToAddress(pAddr + view_as<Address>(i), Data[i], NumberType_Int8);
	}
}

// Return offsetted address
stock Address GameConfGetAddressEx(Handle h, const char[] patch, const char[] offset)
{
	Address pAddr = GameConfGetAddress(h, patch);
	
	if(pAddr == Address_Null)
	{
		return Address_Null;
	}
	
	int iOffset = GameConfGetOffset(h, offset);
	
	if(iOffset == -1)
	{
		return pAddr; // There's no offset, return just address
	}
	
	pAddr += view_as<Address>(iOffset);
	return pAddr;
}