Notifications = {}
Notifications.Version = "1.0"
Notifications.Notify = {}
Notifications.Frame = {}
Notifications.Queue = {}
Notifications.Adverts = {}
Notifications.Notify.SlideDuration = 0.5

 -- Lividity TTT notification system
 -- Made by plaidroni

surface.CreateFont("LividityTEXT", {
	font = "Roboto",
	size = 23,
	weight = 500
})

surface.CreateFont("LividityTitle", {
	font = "Roboto",
	size = 80,
	weight = 500
})

function showNotification(text, duration)
	Notifications.Notify.InUse = true
	surface.SetFont( "Trebuchet24" )
	local width, height = surface.GetTextSize(text)
	if width < 60 then width = width + 10 end
	Notifications.Frame = vgui.Create("DFrame")
		Notifications.Frame:SetSize((width  * 1), 40)
		Notifications.Frame:SetPos(0 - Notifications.Frame:GetWide(), ScrH() / 5)
		Notifications.Frame:SetTitle("")
		Notifications.Frame:ShowCloseButton(false)
		Notifications.Frame:SetDraggable(false)
		-- painting the notification
		local DurationBar = Notifications.Frame:GetWide()
		function Notifications.Frame:Paint(w, h)
			draw.RoundedBoxEx(5, 0, 0, width * 1, h, Color(72,72,72), false, true, false, true)
			DurationBar = Lerp( 0.65 * FrameTime(), DurationBar, -2 )
			draw.RoundedBoxEx(0, 0, Notifications.Frame:GetTall() - 10, DurationBar, 10, Color(170,0,0))
		end

	Notifications.Text = vgui.Create("DLabel", Notifications.Frame)
		Notifications.Text:SetSize(Notifications.Frame:GetWide() - 7, Notifications.Frame:GetTall())
		Notifications.Text:SetPos(8,3)
		Notifications.Text:SetFont("LividityTEXT")
		Notifications.Text:SetText(text)
		Notifications.Text:SetTextColor(Color(255,255,255,255))
		Notifications.Text:SetContentAlignment(7)
		Notifications.Text:SetWrap(false)

	-- Slide In Effect // Sound Effect
	surface.PlaySound("Friends/message.wav")
	Notifications.Frame:MoveTo(0, ScrH() / 5, Notifications.Notify.SlideDuration, 0, 2)

	timer.Create("NotificationOpenTimer", duration, 2, function()
		if IsValid(Notifications.Frame) then
			closeNotification(Notifications.Frame)
		end
	end)
end

function closeNotification(notification)
	notification:MoveTo(0 - notification:GetWide(), ScrH() / 5, Notifications.Notify.SlideDuration, 0, 2)
	timer.Simple(Notifications.Notify.SlideDuration, function()
		if IsValid(notification) then
			notification:Close()
			Notifications.Notify.InUse = false
			table.remove(Notifications.Queue, 1)

			--Queue'ing adverts incase theres another advert coming in
			if Notifications.Queue[1] then
	    		showNotification(Notifications.Queue[1], 6)
			end

		end
	end)
end
net.Receive("Currency_Notification",function()
	local text = net.ReadString()
	if !Notifications.Notify.InUse then
		table.insert(Notifications.Queue, text)
		showNotification(text, 6)
	else
		table.insert(Notifications.Queue, text)
	end
end)