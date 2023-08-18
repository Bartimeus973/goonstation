//smallsandman stuff
/mob/living/critter/human/syndicate/wrestling
	name = "Syndicate Wrestler"
	real_name = "Syndicate Wrestler"
	desc = "OH MY GOD HERE COMES A SYNDICATE OPERATIVE TO LAY DOWN SOME PAIN!"
	health_brute = 35
	health_burn = 35
	hand_count = 2
	ai_type = /datum/aiHolder/aggressive
	var/mob/living/carbon/human/target = null
	var/no_corpse = TRUE

	post_setup()
		src.name = "[syndicate_name()] Wrestler"
		src.real_name = src.name
		src.desc = initial(src.desc)

	valid_target(mob/living/C)
		if (isintangible(C)) return FALSE
		if (isdead(C)) return FALSE
		if (C != src.target) return FALSE
		return TRUE

	setup_hands()
		..()
		var/datum/handHolder/HH = hands[1]
		HH.icon = 'icons/mob/hud_human.dmi'
		HH.limb = new /datum/limb
		HH.name = "left hand"
		HH.suffix = "-L"
		HH.icon_state = "handl"
		HH.limb_name = "left arm"
		HH.can_hold_items = FALSE

		HH = hands[2]
		HH.icon = 'icons/mob/hud_human.dmi'
		HH.limb = new /datum/limb
		HH.name = "right hand"
		HH.suffix = "-R"
		HH.icon_state = "handr"
		HH.limb_name = "right arm"

	death(gibbed)
		if (src.no_corpse)
			spawn_beam(src.loc)
			qdel(src)
		else
			. = ..()
