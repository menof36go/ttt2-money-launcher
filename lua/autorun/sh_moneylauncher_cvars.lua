if SERVER then
	AddCSLuaFile()
	if file.Exists("scripts/sh_convarutil.lua", "LUA") then
		AddCSLuaFile("scripts/sh_convarutil.lua")
		print("[INFO][Money Launcher] Using the utility plugin to handle convars instead of the local version")
	else
		AddCSLuaFile("scripts/sh_convarutil_local.lua")
		print("[INFO][Money Launcher] Using the local version to handle convars instead of the utility plugin")
	end
end

if file.Exists("scripts/sh_convarutil.lua", "LUA") then
	include("scripts/sh_convarutil.lua")
else
	include("scripts/sh_convarutil_local.lua")
end

-- Must run before hook.Add
local cg = ConvarGroup("Moneylauncher", "Money Launcher")
Convar(cg, false, "ttt_moneylauncher_automaticFire", 0, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Enable automatic fire", "bool")
Convar(cg, false, "ttt_moneylauncher_damage", 100, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Damage dealt on impact", "int", 1, 500)
Convar(cg, false, "ttt_moneylauncher_randomDamage", 5, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Applied on top of the normal damage (+/-)", "int", 1, 200)
Convar(cg, false, "ttt_moneylauncher_ammo", 3, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Default ammo the moneygun has when bought", "int", 1, 255)
Convar(cg, false, "ttt_moneylauncher_clipSize", 3, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Clipsize of the moneygun", "int", 1, 255)
Convar(cg, false, "ttt_moneylauncher_rps", 0.4, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, "Bundles of money to shoot per second", "float", 0.01, 10, 2)
--
--generateCVTable()
--