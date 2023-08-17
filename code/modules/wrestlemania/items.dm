//Emerald stuff
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

//Solenoid stuff

//It was simpler to make a reskinned sword which looks and swings like a crowbar than making a crowbar that has a katana dash
/obj/item/swords/katana/gordon
	name = "worn stolen crowbar"
	desc = "A crowbar that used to be in the repair department of a now long-forgotten outpost. Deceptively light, allowing it to be swung with ease."
	icon = 'icons/obj/items/tools/crowbar.dmi'
	inhand_image_icon = 'icons/mob/inhand/tools/crowbar.dmi'
	icon_state = "crowbar-red"
	delimb_prob = 0
	force = 8
	contraband = 0
	hit_type = DAMAGE_BLUNT
	w_class = W_CLASS_NORMAL
	attack_verbs = "smashes"
	hitsound = 'sound/impact_sounds/Generic_Hit_1.ogg'
	custom_suicide = 0
