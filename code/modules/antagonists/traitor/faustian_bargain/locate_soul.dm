/datum/targetable/faustian/locate_soul
	icon_state = "clairvoyance" //todo
	name = "Locate debtor"
	desc = "Track any person who has signed one of your contracts if their soul is corrupted enough."
	targeted = 0
	cooldown = 1 SECOND
	var/active = FALSE
	var/image/arrow = null
	var/hudarrow_color = "#a51f1f"
	var/mob/living/carbon/human/target = null

	New()
		..()
		arrow = image('icons/obj/items/pinpointers.dmi', icon_state = "")

	cast(mob/target)
		if (!holder)
			return 1
		var/mob/living/owner = holder.owner
		if (!owner)
			return 1
		if (!isdiabolical(owner))
			boutput(owner, SPAN_ALERT("You aren't evil enough to use this power!"))
			boutput(owner, SPAN_ALERT("Also, you should probably contact a coder because something has gone horribly wrong."))
			return 1
		. = ..()

		active = !active
		if (!active)
			src.remove_arrow(owner)
		else
			var/list/mob/living/carbon/human/debtors = list()
			for_by_tcl(H, /mob/living/carbon/human)//Todo locate corpses
				if (H.mind && H.mind.soul < 100)
					debtors["[H.name]"] += H
				else if (H.client?.mob?.mind?.soul < 100)
					debtors["[H.name]"] += H
				else if (H.ghost && (H.ghost.mind || H.ghost.client))
					var/mob/dead/ghost = H.ghost
					if(ghost.mind?.soul < 100)
						debtors["[H.name]"] += H
					else if (ghost.client?.mob?.mind?.soul < 100)
						debtors["[H.name]"] += H

			var/choice = tgui_input_list(owner, "Pick a debtor to track.", "[src]", debtors)
			if(isnull(choice))
				return
			src.target = choice
			owner.AddComponent(/datum/component/tracker_hud, src.target, src.hudarrow_color)

	proc/remove_arrow(var/mob/living/owner)
		owner.ClearSpecificOverlays("arrow")
		var/datum/component/tracker_hud/arrow = owner.GetComponent(/datum/component/tracker_hud)
		arrow?.RemoveComponent()
