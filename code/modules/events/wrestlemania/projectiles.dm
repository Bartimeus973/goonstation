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
