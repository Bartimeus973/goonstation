//Dio chasek stuff
/datum/projectile/pie/chem_ingest
	var/list/possible_chems = list("capsaicin", "fliptonium", "fartonium", "LSD", "glitter", "itching", "flubber")

	on_hit(atom/hit, angle, var/obj/projectile/P)
		if (ismob(hit))
			var/mob/M = hit
			playsound(hit, 'sound/impact_sounds/Slimy_Splat_1.ogg', 100, 1)
			M.change_eye_blurry(5)
			if (istype(M, /mob/living/carbon))
				var/mob/living/carbon/C = M
				if (prob(3)) //AND HERE COMES SENATOR BADMAN WITH THE STEEL BOOTS!
					C.reagents?.add_reagent("badmanjuice", 10)
				else
					C.reagents?.add_reagent(pick(possible_chems), 5)

//8c2v/Chanic stuff
//Stolen from special/homing/travel and repurposed for flair
/datum/projectile/special/homing/electric
	name = "pure lightning energy"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energyorb"
	auto_find_targets = 0
	max_speed = 30
	start_speed = 30


	shot_sound = 'sound/effects/electric_shock.ogg'
	goes_through_walls = 1
	goes_through_mobs = 1

	silentshot = 1

	on_launch(var/obj/projectile/P)
		..()
		if (!("owner" in P.special_data))
			P.die()
			return
		var/mob/carryme = P.special_data["owner"]
		carryme.set_loc(P)

	tick(var/obj/projectile/P)
		..()

		if (!(P.targets && P.targets.len && P.targets[1] && !(P.targets[1]:disposed)))
			P.die()
		if (get_turf(P) == P.targets[1])
			P.die()

	on_end(var/obj/projectile/P)
		if (("owner" in P.special_data) && P.proj_data == src)
			var/mob/dropme = P.special_data["owner"]

			if (("insert_owner" in P.special_data) && P.special_data["insert_owner"])
				dropme.set_loc(P.special_data["insert_owner"])
			else
				if (dropme.loc == P)
					dropme.set_loc(get_turf(P))
		elecflash(get_turf(P))
		..()
