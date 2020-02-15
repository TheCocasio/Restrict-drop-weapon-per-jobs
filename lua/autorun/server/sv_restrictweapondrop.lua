RestrictedDroppingWeapon2 = {}

resource.AddFile("resource/fonts/BEBAS.TTF")

util.AddNetworkString("RestrictDropWeapons::restrictdropweaponclient")
util.AddNetworkString("RestrictDropWeapons::StockRESTRICT")
util.AddNetworkString("RestrictDropWeapons::StockAUTORIZE")
CreateConVar( "sv_restrictdropweaponauto", "0", 8192, "Restrict weapons of jobs !" )  

local F = {}

local sv_restrictdropweaponauto = GetConVar( "sv_restrictdropweaponauto" )

if sv_restrictdropweaponauto:GetInt() == 0 then
	hook.Add( "PlayerSay", "RestrictDROPWEAPONCHAT", function( ply, text, public )
		text = string.lower( text ) -- Make the chat message entirely lowercase
		if ( text == "!restrictdropweapon" ) then
			if ply:IsSuperAdmin() then
				net.Start("restrictdropweaponclient")
				net.Send(ply)
				return ""
			end
		end
	end )
	F.canDropWeaponByTheCocasio = function(ply,weapon2)
		for k , v in pairs(RPExtraTeams) do
			if RestrictedDroppingWeapon2[v.command] ~= nil then
				if k == ply:Team() then
					if RestrictedDroppingWeapon2[v.command][weapon2:GetClass()] then
						return false
					else	
						return
					end
				else
					return
				end
			end
		end
	end
	hook.Add("canDropWeapon","canDropWeaponByTheCocasio", F.canDropWeaponByTheCocasio)
else
	F.canDropWeaponByTheCocasio2 = function(ply,weapon2)
		for k , v in pairs(RPExtraTeams) do
			if table.HasValue(v.weapons,weapon2:GetClass()) then

				return false
			else
				return
			end
		end
	end
	hook.Add("canDropWeapon","canDropWeaponByTheCocasio2", F.canDropWeaponByTheCocasio2)
end

F.SaveRestrictionDropWeapon = function()

		print("Save Settings restrictions !")
		if not file.Exists( "restrictiondropweapon", "DATA" ) then
			file.CreateDir( "restrictiondropweapon" )
		end

		for k , v in pairs(RPExtraTeams) do
			if RestrictedDroppingWeapon2[v.command] ~= nil then
				print("Sauvegarde de la restriction pour le métier ".. v.name)
				file.Write( "restrictiondropweapon/table".. v.command .. ".txt", util.TableToJSON(RestrictedDroppingWeapon2[v.command]) )
			end
		end
end
hook.Add("Shutdown", "RestrictDROPWEAPONSAVESHUTDOWN",F.SaveRestrictionDropWeapon)

F.LoadRestrictionDropWeapon = function()
	if sv_restrictdropweaponauto:GetInt() == 0 then
		print("Load Settings restrictions !")
		for k , v in pairs(RPExtraTeams) do
			if file.Exists( "restrictiondropweapon/table".. v.command .. ".txt", "DATA" ) then 
				print("Chargement de la restriction pour le métier ".. v.name)
				local insertrestriction = util.JSONToTable(file.Read( "restrictiondropweapon/table".. v.command .. ".txt", "DATA" ))
				if RestrictedDroppingWeapon2[v.command] == nil then
					RestrictedDroppingWeapon2[v.command] = {}
					table.Merge( RestrictedDroppingWeapon2[v.command], insertrestriction )
					hook.Add("canDropWeapon","canDropWeaponByTheCocasio", F.canDropWeaponByTheCocasio)
				end
			end
		end
	end
end

hook.Add("PostGamemodeLoaded", "RestrictDROPWEAPONLOAD",F.LoadRestrictionDropWeapon)

F.StockRestrict = function(ply,jobname,command,weapons)
	if RestrictedDroppingWeapon2[command] == nil then
		RestrictedDroppingWeapon2[command] = {}
	end
	for k , v in pairs(weapons) do

		if RestrictedDroppingWeapon2[command][v] then

			DarkRP.notify(ply, 1, 8, "L'arme " .. v .. " est déjà restreinte !")

		else

			DarkRP.notify(ply, 0, 8, "Vous avez restreint le métier " .. jobname .. " de lacher l'arme " .. v .. " !")
			RestrictedDroppingWeapon2[command][v] = true
			hook.Add("canDropWeapon","canDropWeaponByTheCocasio", canDropWeaponByTheCocasio)
			F.SaveRestrictionDropWeapon()
		end
	end
end

net.Receive("RestrictDropWeapons::StockRESTRICT", function(len,ply)

	if not ply:IsSuperAdmin() then return end
	
	local jobname = net.ReadString()
	local command = net.ReadString()
	local weapons = net.ReadTable()
	
	F.StockRestrict(ply,jobname,command,weapons)

end)

F.StockAUTORIZE = function(ply,jobname,command,weapons)

	if RestrictedDroppingWeapon2[command] == nil then
		return DarkRP.notify(ply, 1, 8, "Il n'y a aucune restriction avec ce métier !")
	end

	for k , v in pairs(weapons) do

		if RestrictedDroppingWeapon2[command][v] then
			DarkRP.notify(ply, 0, 8, "Vous avez autorisé le métier " .. jobname .. " de lacher l'arme " .. v .. " !")
			RestrictedDroppingWeapon2[command][v] = nil
			hook.Add("canDropWeapon","canDropWeaponByTheCocasio", F.canDropWeaponByTheCocasio)
			F.SaveRestrictionDropWeapon()
		else
			DarkRP.notify(ply, 1, 8, "Il n'y a aucune restriction avec cette arme pour ce métier !")
		end
	end

end

net.Receive("RestrictDropWeapons::StockAUTORIZE", function(len,ply)

	if not ply:IsSuperAdmin() then return end

	local jobname = net.ReadString()
	local command = net.ReadString()
	local weapons = net.ReadTable()

	F.StockAUTORIZE(ply,jobname,command,weapons)

end)
