RestrictedDroppingWeapon2 = {}

resource.AddFile("resource/fonts/BEBAS.TTF")

util.AddNetworkString("restrictdropweaponclient")
util.AddNetworkString("StockRESTRICT")
util.AddNetworkString("StockAUTORIZE")
CreateConVar( "sv_restrictdropweaponauto", "0", 8192, "Restrict weapons of jobs !" )  

local sv_restrictdropweaponauto = GetConVar( "sv_restrictdropweaponauto" )

if sv_restrictdropweaponauto:GetInt() == 0 then

	hook.Add( "PlayerSay", "RestrictDROPWEAPONCHAT", function( ply, text, public )
		text = string.lower( text ) -- Make the chat message entirely lowercase
		if ( text == "!restrictdropweapon" ) then
			net.Start("restrictdropweaponclient")
			net.WriteEntity(ply)
			net.Send(ply)
			return ""
		end
	end )

	function canDropWeaponByTheCocasio(ply,weapon2)
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

	hook.Add("canDropWeapon","canDropWeaponByTheCocasio", canDropWeaponByTheCocasio)

else

	function canDropWeaponByTheCocasio2(ply,weapon2)

		for k , v in pairs(RPExtraTeams) do

			if table.HasValue(v.weapons,weapon2:GetClass()) then

				return false

			else
				return
			end

		end
				

	end

	hook.Add("canDropWeapon","canDropWeaponByTheCocasio2", canDropWeaponByTheCocasio2)

end

function SaveRestrictionDropWeapon()

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


hook.Add("Shutdown", "RestrictDROPWEAPONSAVESHUTDOWN",SaveRestrictionDropWeapon)

function LoadRestrictionDropWeapon()

		if sv_restrictdropweaponauto:GetInt() == 0 then

			print("Load Settings restrictions !")

			for k , v in pairs(RPExtraTeams) do

				if file.Exists( "restrictiondropweapon/table".. v.command .. ".txt", "DATA" ) then 
					print("Chargement de la restriction pour le métier ".. v.name)
					local insertrestriction = util.JSONToTable(file.Read( "restrictiondropweapon/table".. v.command .. ".txt", "DATA" ))
					if RestrictedDroppingWeapon2[v.command] == nil then
						RestrictedDroppingWeapon2[v.command] = {}
						table.Merge( RestrictedDroppingWeapon2[v.command], insertrestriction )
						hook.Add("canDropWeapon","canDropWeaponByTheCocasio", canDropWeaponByTheCocasio)
					end
				end

			end

		end


end

hook.Add("PostGamemodeLoaded", "RestrictDROPWEAPONLOAD",LoadRestrictionDropWeapon)

function StockRestrict(ply,jobname,command,weapons)


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
				SaveRestrictionDropWeapon()


			end

	end

	PrintTable(RestrictedDroppingWeapon2[command])

end

net.Receive("StockRESTRICT", function(len,ply)

	local ply = net.ReadEntity()
	local jobname = net.ReadString()
	local command = net.ReadString()
	local weapons = net.ReadTable()
	
	StockRestrict(ply,jobname,command,weapons)

end)

function StockAUTORIZE(ply,jobname,command,weapons)

	if RestrictedDroppingWeapon2[command] == nil then
		return DarkRP.notify(ply, 1, 8, "Il n'y a aucune restriction avec ce métier !")
	end

	for k , v in pairs(weapons) do

			if RestrictedDroppingWeapon2[command][v] then

				DarkRP.notify(ply, 0, 8, "Vous avez autorisé le métier " .. jobname .. " de lacher l'arme " .. v .. " !")
				RestrictedDroppingWeapon2[command][v] = nil
				hook.Add("canDropWeapon","canDropWeaponByTheCocasio", canDropWeaponByTheCocasio)
				SaveRestrictionDropWeapon()

			else
				DarkRP.notify(ply, 1, 8, "Il n'y a aucune restriction avec cette arme pour ce métier !")
			end

	end

end

net.Receive("StockAUTORIZE", function(len,ply)

	local ply = net.ReadEntity()
	local jobname = net.ReadString()
	local command = net.ReadString()
	local weapons = net.ReadTable()

	StockAUTORIZE(ply,jobname,command,weapons)

end)