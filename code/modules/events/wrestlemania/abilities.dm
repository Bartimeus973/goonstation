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
			M.changeStatus("stunned", 2 SECONDS)
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

		var/obj/item/grab/G = src.grab_check(null, 2, 1)
		if (!G || !istype(G))
			return TRUE
		var/mob/living/carbon/human/T = G.affecting

		if (!istype(T))
			boutput(C, "<span class='alert'>You cannot do this on a non human target.</span>")
			return TRUE

		T.set_loc(C.loc)
		T.emote("scream")
		C.visible_message("<span class='alert'>[C] begins rapidly spinning around while holding [T]'s arm tightly in their mouth, bringing both of them to the floor!</span>")
		T.changeStatus("weakened", 6 SECONDS)
		C.changeStatus("weakened", 4 SECONDS)
		T.force_laydown_standup()
		C.force_laydown_standup()
		for (var/i in 1 to 20)
			T.set_dir(turn(T.dir, 90))
			C.set_dir(turn(C.dir, 90))
			if (i % 2 == 0)
				T.pixel_y = pick(-6, 6)
				T.pixel_x = pick(-6, 6)
			if ((i % 4) == 0)
				bleed(T, 10, 5, T.loc)
				playsound(holder.owner.loc, pick('sound/impact_sounds/Flesh_Tear_1.ogg', 'sound/impact_sounds/Flesh_Tear_2.ogg', 'sound/impact_sounds/Flesh_Tear_3.ogg'), 70, 0, 0)
				random_brute_damage(T, 5)
			sleep(0.15 SECONDS)
		T.pixel_y = 0
		T.pixel_x = 0
		return FALSE

//Wrench_1 stuff
/datum/targetable/wrestlemania/sit_down_clown
	name = "SIT DOWN, CLOWN!"
	desc = "Use your commanding voice to get someone to sit the hell down for a sec."
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "scream"
	targeted = 1
	cooldown = 30 SECONDS

	cast(atom/target)
		var/mob/T = target
		if (!isalive(T))
			boutput("<span class='notice'>They are already sitting down.</span>")
			return TRUE
		var/speechpopupstyle = "font-size: 16px;"
		var/map_text = make_chat_maptext(holder.owner.loc, "SIT DOWN, CLOWN!", "color: [rgb(53, 7, 255)];" + speechpopupstyle, alpha = 255, time = 4 SECONDS)
		var/list/mob/living/mob_list = list()
		for (var/mob/living/M in hearers(holder.owner))
			M.show_message(assoc_maptext = map_text)
			mob_list += M
		holder.owner.visible_message("<span class='alert'>[holder.owner] shouts in a booming voice, starring at [T]. The crowd feels compelled to join in!</span>")
		SPAWN(1 SECONDS)
			for (var/mob/living/M in mob_list)
				if (isalive(M) && (M != T) && (M != holder.owner))
					M.say("SIT DOWN, CLOWN!")
			T.changeStatus("weakened", 5 SECONDS)
			T.force_laydown_standup()
			T.visible_message("<span class='alert'>[T] falls to their knees, submitting to authority.</span>", "<span class='alert'>Your knees buckle under you, such a shout is commending immediate attention!</span>")
		return FALSE

/datum/targetable/wrestlemania/summon_baseball_bat
	name = "Manifest bat"
	desc = "Make a discreet sign to have one of your agents drop a baseball bat from the ceiling"
	cooldown = 1 MINUTE
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "Drop"
	targeted = 0
	target_anything = 0

	cast(atom/target)
		holder.owner.visible_message("<span class='notice'>[holder.owner] twitches lightly and a baseball bat is dropped from the ceiling!</span>", "<span class='notice'>You do a small sign and notify your fellow anarchists to drop you a baseball bat.</span>")
		var/obj/item/bat/the_bat = new /obj/item/bat(holder.owner.loc)
		the_bat.alpha = 0
		the_bat.pixel_y = 128
		animate(the_bat, alpha=255, time=0.5 SECONDS)
		animate(the_bat, time = 1.2 SECONDS, pixel_y = 0, flags = ANIMATION_PARALLEL)
		animate(the_bat, time = 1.2 SECONDS,  flags = ANIMATION_PARALLEL)
		animate(time= 2 DECI SECONDS, pixel_y = 6, easing = SINE_EASING | EASE_OUT)
		animate(time = 2 DECI SECONDS, pixel_y = 0, , easing = SINE_EASING | EASE_IN)
		return FALSE

//Emerald stuff
/datum/targetable/wrestlemania/summon_throne
	name = "Summon throne/Unsummon throne"
	desc = "Summon your magnificent throne from thin air to your subject's delight or send it back where it came from."
	cooldown = 5 SECONDS
	targeted = 0
	target_anything = 0
	var/obj/stool/chair/comfy/throne_gold/wrestler/our_throne = null

	cast(atom/target)
		if (our_throne)
			holder.owner.visible_message("<span class='notice'>[holder.owner] makes a dismissive gesture and their throne disappears!</span>")
			leaving_animation(our_throne)
			SPAWN (3 SECONDS)
				qdel(our_throne)
				src.our_throne = null
		else
			holder.owner.visible_message("<span class='notice'>[holder.owner] raises his hands and a regal throne appears from thin air underneath them!</span>")
			our_throne = new /obj/stool/chair/comfy/throne_gold/wrestler(holder.owner.loc)
			our_throne.my_king = holder.owner
			spawn_animation1(our_throne)
			our_throne.Scale(1.5, 1.5)
		return FALSE

/obj/stool/chair/comfy/throne_gold/wrestler
	var/mob/living/my_king = null

	buckle_in(mob/living/to_buckle, mob/living/user, var/stand = 0)
		if (to_buckle != my_king)
			to_buckle.visible_message("<span class='alert'>[to_buckle] attempts to sit down on the throne but they slip off instead!</span>")
			ThrowRandom(to_buckle, 3, 1)
			to_buckle.setStatus("weakened", 2 SECOND)
			to_buckle.force_laydown_standup()
			playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			return FALSE
		..()

/datum/targetable/wrestlemania/summon_peels
	name = "Command peels"
	desc = "Exert some of your power to command the universe to form banana peels out of thin air."
	cooldown = 20 SECONDS
	targeted = 0
	target_anything = 0
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "lesser"
	var/max_peels = 3

	cast(atom/target)
		var/list/turf/simulated/floor/turf_list = list()
		for (var/turf/simulated/floor/T in range(holder.owner, 3))
			turf_list += T
		if (turf_list.len < max_peels)
			boutput(holder.owner, "<span class='notice'>There isn't enough space to summon your peels here!</span>")
			return TRUE
		holder.owner.visible_message("<span class='notice'>[holder.owner] raises one hand in a focused gesture. You spot banana peels coming out of the ground around them!</span>")
		for (var/i in 0 to max_peels)
			var/turf/simulated/floor/picked_turf = pick(turf_list)
			var/obj/item/bananapeel/new_peel = new /obj/item/bananapeel(picked_turf)
			animate_buff_in(new_peel)
		return FALSE

//Bartimeus stuff
/datum/targetable/wrestlemania/cast_lightning
	name = "Summon lightning"
	desc = "Strike down a bolt of lightning. You totally meant to do that"
	cooldown = 1 SECOND
	targeted = 1
	target_anything = 1
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "grasp"

	cast(atom/target)
		var/turf/T = null
		if (!isturf(target))
			T = get_turf(target)
		else
			T = target
		if (!T)
			boutput(holder.owner, "<span class='notice'>That is not a valid target</span>")
			return TRUE
		lightning_bolt_weak(T, holder.owner)
		return FALSE

//Copy paste from regular "lightning_bolt()" proc, but weak and with little damage
/proc/lightning_bolt_weak(atom/center, var/caster)
	showlightning_bolt(center)
	playsound(center, 'sound/effects/lightning_strike.ogg', 70, 1)
	elecflash(center,0, power=1, exclude_center = 0)

	for(var/mob/living/M in range(1,center))
		if (M.bioHolder?.HasEffect("resist_electric"))
			boutput(M, "<span class='notice'>The lightning bolt arcs around you harmlessly.</span>")
		else if (check_target_immunity(M))
			continue
		else
			M.TakeDamage("chest", 0, 5, 0, DAMAGE_BURN)
			boutput(M, "<span class='alert'>You feel a strong electric shock!</span>")
			M.do_disorient(stamina_damage = 10, weakened = 0, stunned = 0, disorient = 5)
			if (M.loc == center)
				M.TakeDamage("chest", 0, 5, 0, DAMAGE_BURN)
				M.emote("scream")

//Solenoid stuff
/datum/targetable/wrestlemania/throw_coins
	name = "Monetary gambit"
	desc = "Years of numismatism has taught you a thing or two about the practicality of throwing coins around"
	cooldown = 15 SECONDS
	targeted = 0
	target_anything = 0

	cast(atom/target)
		holder.owner.visible_message("<span class='notice'>[holder.owner] reaches into their pockets and pulls out a small handfull of ancient coins, then throws them around [himself_or_herself(holder.owner)]</span>")
		for (var/i in 1 to 10)
			var/obj/item/coin/new_coin = new /obj/item/coin(holder.owner.loc)
			var/throw_direction = get_edge_target_turf(holder.owner, i)
			new_coin.throw_at(throw_direction, rand(2,3), 1, throw_type = THROW_NORMAL)
		return FALSE

//Luminous aether stuff
/datum/targetable/wrestlemania/glitter_cloud
	name = "Glitter storm"
	desc = "OH GOD THAT'S WAY TOO MUCH GLITTER!"
	cooldown = 20 SECONDS
	targeted = 0
	target_anything = 0

	cast(atom/target)
		var/turf/T = get_turf(holder.owner)
		T?.fluid_react_single("sparkles", 10, airborne = 1)
		holder.owner.visible_message("<span class='notice'>[holder.owner] does a little twirl and a MASSIVE cloud of rainbow glitter comes off of them!</span>", "<span class='notice'>You do a little twirl and unleash some of your glitter power!</span>")
		return FALSE

/datum/targetable/geneticsAbility/bigpuke/glitter
	name = "Vomit glitter"
	desc = "AAHHH, IT'S IN MY MOUTH! BLLLAARRFGHGH!"
	cooldown = 20 SECONDS
	puke_reagents = list("glitter" = 20, "lumen" = 20)
