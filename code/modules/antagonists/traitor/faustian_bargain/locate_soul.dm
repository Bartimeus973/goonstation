/datum/targetable/faustian/locate_soul
	icon_state = "clairvoyance" //todo
	name = "Locate debtor"
	desc = "Track any person who has signed one of your contracts for a time."
	targeted = 0
	cooldown = 60 SECOND
	var/active = FALSE
	var/image/arrow = null
	var/hudarrow_color = "#a51f1f"
	var/duration = 10 SECONDS

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

		var/list/mob/living/carbon/human/debtors = list()
		for_by_tcl(H, /mob/living/carbon/human)
			if (H.z != owner.z)
				continue
			if (H.mind && H.mind.soul < 100)
				debtors["[H.name]"] += H
			else if (H.client && H.client.mob && H.client.mob.mind?.soul < 100)
				debtors["[H.name]"] += H
			else if (H.ghost && (H.ghost.mind || H.ghost.client))
				var/mob/dead/ghost = H.ghost
				if(ghost.mind?.soul < 100)
					debtors["[H.name]"] += H
				else if (ghost.client?.mob?.mind?.soul < 100)
					debtors["[H.name]"] += H

		if (debtors.len == 0)
			boutput(owner, SPAN_NOTICE("You have no debtors to tracks or they can't be found!"))
			return 1

		var/choice = tgui_input_list(owner, "Pick a debtor to track.", "[src]", debtors)
		if(isnull(choice))
			return 1
		if(isnull(debtors[choice]))
			boutput(owner, SPAN_NOTICE("The target can't be found for some reason. Maybe they no longer exist. Try again?"))
			return 1
		owner.AddComponent(/datum/component/tracker_hud, debtors[choice], src.hudarrow_color)
		SPAWN(src.duration)
			if (owner)
				src.remove_arrow(owner)
				boutput(owner, SPAN_NOTICE("Your focus wanes, you lose the precise location of the debtor."))

	proc/remove_arrow(var/mob/living/owner)
		var/datum/component/tracker_hud/arrow = owner.GetComponent(/datum/component/tracker_hud)
		arrow?.RemoveComponent()
