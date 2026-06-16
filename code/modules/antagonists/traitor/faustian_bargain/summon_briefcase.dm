/datum/targetable/faustian/summon_briefcase
	icon_state = "clairvoyance" //todo
	name = "Summon Briefcase"
	desc = "Immediatly summon your briefcase back to your hand."
	targeted = 0
	cooldown = 180 SECONDS

	cast(mob/target)
		if (!holder)
			return 1
		var/mob/living/M = holder.owner
		if (!M)
			return 1
		if (!isdiabolical(M))
			boutput(M, SPAN_ALERT("You aren't evil enough to use this power!"))
			boutput(M, SPAN_ALERT("Also, you should probably contact a coder because something has gone horribly wrong."))
			return 1
		. = ..()

		var/list/briefcases = list()
		var/we_hold_it = FALSE

		//Adapted from "summon machete" of the slasher antag
		for_by_tcl(K, /obj/item/storage/briefcase/faustian)
			if (M.mind && M.mind.key == K.faustian_key)
				if (K == M.find_in_hand(K))
					we_hold_it = TRUE
					continue
				if (!(K in briefcases))
					briefcases["[K.name] #[length(briefcases) + 1] [ismob(K.loc) ? "carried by [K.loc.name]" : "at [get_area(K)]"]"] += K

		switch (length(briefcases))
			if (-INFINITY to 0)
				if (we_hold_it)
					boutput(M, SPAN_ALERT("You're already holding your briefcase."))
					return TRUE
				else
					boutput(M, SPAN_ALERT("The smell of hot leather fills your mind as your manifest another infernal briefcase from nothing."))
					var/obj/item/storage/briefcase/faustian/N = new /obj/item/storage/briefcase/faustian(get_turf(M))
					N.faustian_key = M.mind?.key
					M.put_in_hand_or_drop(N)
					return FALSE

			if (1)
				var/obj/item/storage/briefcase/faustian/W = briefcases[briefcases[1]]

				if (!istype(W))
					boutput(M, SPAN_ALERT("You are unable to summon your briefcase. Something has gone wrong."))
					return TRUE

				src.send_briefcase_to_target(W, M)

			if (2 to INFINITY)
				var/t1 = input("Please select a briefcase to summon", "Target Selection", null, null) as null|anything in briefcases
				if (!t1)
					return TRUE

				var/obj/item/storage/briefcase/faustian/K2 = briefcases[t1]

				if (!M || !ismob(M) || !isliving(M) || !M.mind)
					return TRUE
				if (!istype(K2))
					boutput(M, SPAN_ALERT("You are unable to summon your briefcase."))
					return TRUE
				if (M.mind.key != K2.faustian_key)
					boutput(M, SPAN_ALERT("You are unable to summon your briefcase. That briefcase doesn't appear to be yours somehow."))
					return TRUE

				src.send_briefcase_to_target(K2, M)

		return 0

	///Actually sending the briefcase to the faustian lawyer if one exists already
	proc/send_briefcase_to_target(obj/item/I, mob/living/M)
		if(!istype(I))
			return

		I.visible_message(SPAN_ALERT("<b>The [I.name] is suddenly burnt into a pile of ash!</b>"))
		fireflash(I, 0, chemfire = CHEM_FIRE_RED)
		playsound(I, 'sound/effects/mag_fireballlaunch.ogg', 50, FALSE)

		if(ismob(I.loc))
			M.u_equip(I)
		I.stored?.transfer_stored_item(I, get_turf(I))
		if(istype(I.loc, /mob/living))
			var/mob/living/L = I.loc
			L.drop_item(I)
		I.set_loc(get_turf(src))
		if(!M.put_in_hand(I))
			boutput(M, SPAN_ALERT("The smell of hot leather fills your mind as your manifest another infernal briefcase close to you."))
		else
			boutput(M, SPAN_ALERT("The smell of hot leather fills your mind as your manifest another infernal briefcase to your hand."))

		return
