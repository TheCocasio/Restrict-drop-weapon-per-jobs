surface.CreateFont( "restrictweapondropbebas", {
	font = "Bebas", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 74,
	weight = 500,
} )

surface.CreateFont( "restrictweapondropbebas2", {
	font = "Bebas", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 60,
	weight = 500,
} )

surface.CreateFont( "restrictweapondropbebas3", {
	font = "Bebas", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 500,
} )

local function RestrictDropWeaponClient(ply)

	local stockrestrictclient = {}

	--PrintTable(RPExtraTeams)

	local background = vgui.Create("DFrame")
	background:SetSize(1155,611)
	background:Center()
	background:ShowCloseButton(false)
	background:MakePopup()
	background:SetTitle( " 	" )
	background.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,Color(19,19,19,220))
		draw.SimpleText("RESTRICT DROP WEAPON","restrictweapondropbebas",w/2,30,Color(255,255,255,255),1) -- PIXEL OF FONT BEBAS = 74
	end

	local buttonclose = vgui.Create("DButton",background)
	buttonclose:SetSize(116,35)
	buttonclose:SetPos(background:GetWide() - 126 , 8)
	buttonclose:SetText("X")
	buttonclose:SetColor(Color(255,255,255,255))
	buttonclose.Paint = function(self,w,h)

		draw.RoundedBox(0,0,0,w,h,Color(178,25,25,255))

	end
	buttonclose.DoClick = function()
		background:Close()
	end



	local listjobsBACKGROUND = vgui.Create("DFrame", background)
	listjobsBACKGROUND:SetDraggable(false)
	listjobsBACKGROUND:SetPos(10,133)
	listjobsBACKGROUND:ShowCloseButton(false)
	listjobsBACKGROUND:SetSize(509,346)
	listjobsBACKGROUND:SetTitle(" ")
	listjobsBACKGROUND.Paint = function(self,w,h)

		draw.RoundedBox(0,	0,	0,	w,	h,	Color(178,	25,	25,	255))
		draw.DrawText("Metiers",	"restrictweapondropbebas3",	w/2 - 8,	0,	Color(255,255,255,255),	1)

	end

	local DScrollPanel = vgui.Create( "DScrollPanel", listjobsBACKGROUND )
	DScrollPanel:Dock( FILL )
	DScrollPanel:SetPos(0,-40)

	local listjobs = {}


	for k,v in pairs(RPExtraTeams) do
    	
    	listjobs[k] = DScrollPanel:Add( "DButton" )
    	listjobs[k].toggleofbutton = false
    	listjobs.toggleofbuttonTOGGLE = true
		listjobs[k]:SetPos(0,k * 40 - 30)
		listjobs[k]:SetSize(480,40)
		listjobs[k]:SetColor(Color(255,255,255,255))
		listjobs[k]:SetText(v.name)
		listjobs[k].Paint = function(self,w,h)

			if k % 2 == 0 then
			draw.RoundedBox(0,	0,	0,	w,	h,	Color(49,49,49,255))
			else
			draw.RoundedBox(0,	0,	0,	w,	h,	Color(62,62,62,255))
			end
			if self:IsHovered() then
				draw.RoundedBox(0,	0,	0,	w,	h,	Color(255,62,62,255))
			end
			if listjobs[k].toggleofbutton then
				draw.RoundedBox(0,	0,	0,	w,	h,	Color(62,255,62,255))
			end

		end

		listjobs[k].DoClick = function(self)

			if not listjobs[k].toggleofbutton then
				if listjobs.toggleofbuttonTOGGLE then
					listjobs.toggleofbuttonTOGGLE = false
					listjobs[k].toggleofbutton = true
				else
					listjobs[k].toggleofbutton = false
				end
			else
				listjobs.toggleofbuttonTOGGLE = true
				listjobs[k].toggleofbutton = false
			end

		end

    	

	end


		

	local listweaponsBACKGROUND = vgui.Create("DFrame", background)
	listweaponsBACKGROUND:SetDraggable(false)
	listweaponsBACKGROUND:SetPos(background:GetWide() - 519, 133)
	listweaponsBACKGROUND:ShowCloseButton(false)
	listweaponsBACKGROUND:SetSize(509,346)
	listweaponsBACKGROUND:SetTitle(" ")
	listweaponsBACKGROUND.Paint = function(self,w,h)

		draw.RoundedBox(0,	0,	0,	w,	h,	Color(178,	25,	25,	255))
		draw.DrawText("Armes",	"restrictweapondropbebas3",	w/2 - 8,	0,	Color(255,255,255,255),	1)

	end

	local DScrollPanel = vgui.Create( "DScrollPanel", listweaponsBACKGROUND )
	DScrollPanel:Dock( FILL )
	DScrollPanel:SetPos(0,-40)

	local listweapons = {}


	for k,v in pairs(weapons.GetList()) do
    	
    	listweapons[k] = DScrollPanel:Add( "DButton" )
    	listweapons[k].toggleofbutton = false
		listweapons[k]:SetPos(0,k * 40 - 30)
		listweapons[k]:SetSize(480,40)
		listweapons[k]:SetColor(Color(255,255,255,255))
		listweapons[k]:SetText(v.ClassName)
		listweapons[k].Paint = function(self,w,h)

			if k % 2 == 0 then
			draw.RoundedBox(0,	0,	0,	w,	h,	Color(49,49,49,255))
			else
			draw.RoundedBox(0,	0,	0,	w,	h,	Color(62,62,62,255))
			end
			if self:IsHovered() then
				draw.RoundedBox(0,	0,	0,	w,	h,	Color(255,62,62,255))
			end
			if listweapons[k].toggleofbutton then
				draw.RoundedBox(0,	0,	0,	w,	h,	Color(62,255,62,255))
			end

		end

		listweapons[k].DoClick = function(self)

			if listweapons[k].toggleofbutton then
				listweapons[k].toggleofbutton = false
			else
				listweapons[k].toggleofbutton = true
			end

		end

    	

	end

	local buttonautorize = vgui.Create("DButton",background)
	buttonautorize:SetSize(352,74)
	buttonautorize:SetPos(70 , background:GetTall() - 104)
	buttonautorize:SetText("AUTORISER")
	buttonautorize:SetColor(Color(255,255,255,255))
	buttonautorize:SetFont("restrictweapondropbebas2")
	buttonautorize.Paint = function(self,w,h)

		draw.RoundedBox(0,0,0,w,h,Color(144,144,144,255))

	end
	buttonautorize.DoClick = function()

		net.Start("StockAUTORIZE")
		net.WriteEntity(LocalPlayer())

			for k,v in pairs(RPExtraTeams) do

				if listjobs[k].toggleofbutton then
					net.WriteString(v.name)
					net.WriteString(v.command)
				end

			end
			

			for k,v in pairs(weapons.GetList()) do

				if listweapons[k].toggleofbutton then
					
					table.insert(stockrestrictclient, v.ClassName)
					timer.Create("stockautorizeweapontimer",	0,	1,	function()

						PrintTable(stockrestrictclient)
						net.WriteTable(stockrestrictclient)
						net.SendToServer()
						background:Close()

					end)
					
				end

			end

	end

	local buttonrestrict = vgui.Create("DButton",background)
	buttonrestrict:SetSize(352,74)
	buttonrestrict:SetPos(background:GetWide() - 422 , background:GetTall() - 104)
	buttonrestrict:SetText("RESTREINDRE")
	buttonrestrict:SetColor(Color(255,255,255,255))
	buttonrestrict:SetFont("restrictweapondropbebas2")
	buttonrestrict.Paint = function(self,w,h)

		draw.RoundedBox(0,0,0,w,h,Color(144,144,144,255))

	end
	buttonrestrict.DoClick = function()

		net.Start("StockRESTRICT")
		net.WriteEntity(LocalPlayer())

			for k,v in pairs(RPExtraTeams) do

				if listjobs[k].toggleofbutton then
					net.WriteString(v.name)
					net.WriteString(v.command)
				end

			end
			

			for k,v in pairs(weapons.GetList()) do

				if listweapons[k].toggleofbutton then
					
					table.insert(stockrestrictclient, v.ClassName)
					timer.Create("stockrestrictweapontimer",	0,	1,	function()

						PrintTable(stockrestrictclient)
						net.WriteTable(stockrestrictclient)
						net.SendToServer()
						background:Close()

					end)
					
				end

			end


	end






end

net.Receive("restrictdropweaponclient",function(len,ply)

	local ply = net.ReadEntity()

	RestrictDropWeaponClient(ply)

end)