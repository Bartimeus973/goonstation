//Abilities for the wrestlemania event.

//creathian stuff
/datum/targetable/wrestlemania/bite_grab
	name = "Chomp"
	desc = "Bite down hard on someone and hold them close"
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "bite"
	targeted = 1
	cooldown = 20 SECONDS

	cast(atom/target)
		var/mob/M = target
		if (!(BOUNDS_DIST(M, holder.owner) == 0))
			boutput(holder.owner, "<span class='notice'>You are too far! Somehow.</span>")
			return TRUE
		if (istype(M))
			for (var/obj/item/grab/G in holder.owner)
				if (G.affecting == M)
					return TRUE
			playsound(holder.owner.loc, 'sound/impact_sounds/Flesh_Tear_2.ogg', 70, 0, 0)
			holder.owner.visible_message("<span class='alert'><B>[holder.owner] bites down hard on [M]'s arm and doesnt let go!</B></span>")
			var/obj/item/grab/G = new /obj/item/grab(holder.owner, holder.owner, M)
			holder.owner.put_in_hand(G, holder.owner.hand)
			M.changeStatus("stunned", 4 SECONDS)
			G.state = GRAB_AGGRESSIVE
			G.UpdateIcon()
			holder.owner.set_dir(get_dir(holder.owner, M))
			M.set_loc(holder.owner.loc)
			M.emote("scream")
			random_brute_damage(M, 5)
			hit_twitch(M)
			bleed(M, 10, 5, M.loc)
			return FALSE

/datum/targetable/wrestlemania/death_roll
	name = "Alloy Gator Death Roll"
	desc = "Start twisting around while holding someone's limb in your mouth. Very messy."
	icon = 'icons/mob/werewolf_ui.dmi'
	icon_state = "feast"
	targeted = 0
	target_anything = 0
	cooldown = 40 SECONDS

	cast(atom/target)
		var/mob/living/C = holder.owner

		var/obj/item/grab/G = src.grab_check(null, 3, 1)
		if (!G || !istype(G))
			return TRUE
		var/mob/living/carbon/human/T = G.affecting

		if (!istype(T))
			boutput(C, "<span class='alert'>You cannot do this on a non human target.</span>")
			return TRUE

		T.set_loc(C.loc)
		T.emote("scream")
		C.visible_message("<span class='alert'>[C] begins rapidly spinning around while holding [T]'s arm tightly in their mouth, bringing both of them to the floor!</span>")
		C.force_laydown_standup()
		T.force_laydown_standup()
		T.setStatus("stunned", 6 SECONDS)
		for (var/i in 1 to 15)
			T.set_dir(turn(src.dir, 90))
			C.set_dir(turn(src.dir, 90))
			if ((i % 4) == 0)
				bleed(M, 10, 5, M.loc)
				playsound(holder.owner.loc, pick('sound/impact_sounds/Flesh_Tear_1.ogg', 'sound/impact_sounds/Flesh_Tear_2.ogg', 'sound/impact_sounds/Flesh_Tear_3.ogg'), 70, 0, 0)
			sleep(0.2 SECONDS)
		return FALSE

//Wrench_1 stuff
/datum/targetable/wrestlemania/sit_down_clown
	name = "SIT DOWN, CLOWN!"
	desc = "Use your commanding voice to get everyone to sit the hell down for a sec."
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "scream"
	targeted = 1
	cooldown = 30 SECONDS

	cast(atom/target)
		var/mob/T = target
		if (!isalive(target))
			boutput("<span class='notice'>They are already sitting down.</span>")
			return TRUE
		var/speechpopupstyle = "font-size: 12px;"
		var/map_text = make_chat_maptext(holder.owner.loc, "SIT DOWN, CLOWN!", "color: [rgb(53, 7, 255)];" + src.speechpopupstyle, alpha = 255, time = 4)
		for (var/mob/living/M in hearers(holder.owner))
			M.show_message(assoc_maptext = map_text)
			if (isalive(M) && (M != T) && (M != holder.owner))
				M.say("SIT DOWN, CLOWN!")
			if (!isdead(M) && (M != holder.owner))
				M.force_laydown_standup()
				M.setStatus("stunned", 5 SECONDS)
				M.visible_message("<span class='alert'>[M] falls to their knees, submitting to authority.</span>", "<span class='alert'>Your knees buckle under you, such a shout is commending immediate attention!</span>")
		return FALSE
