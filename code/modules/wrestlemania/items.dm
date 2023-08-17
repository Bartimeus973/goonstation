//Emerald stuff
/obj/stool/chair/comfy/throne_gold/wrestler
	var/mob/living/my_king = null

	buckle_in(mob/living/to_buckle, mob/living/user, var/stand = 0)
		if (!can_buckle(to_buckle,user))//Double check with the parent call, but it's probably okay?
			return FALSE
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

//Smallsandman stuff
/obj/item/clothing/head/helmet/space/nanotrasen/pilot/hunter
	icon = 'code/modules/wrestlemania/icons/items/clothing.dmi'
	wear_image_icon = 'code/modules/wrestlemania/icons/mob/head.dmi'
	icon_state = "hunter_helm"
	item_state = "hunter_helm"
	desc = "A modified NanoTrasen pilot helmet, it's visor is slightly cracked and you can just make out a flickering hud on the inside."

/obj/item/clothing/under/misc/turds/hunter
	desc = "A strange looking jumpsuit, seems worn down."
	icon = 'code/modules/wrestlemania/icons/items/clothing.dmi'
	wear_image_icon = 'code/modules/wrestlemania/icons/mob/clothing.dmi'
	icon_state = "hunter_js"
	item_state = "hunter_js"

/obj/item/clothing/suit/space/hunter
	name = "worn space suit"
	desc = "This space suit is definitely stolen, It's been painted Orange and it's NT reliaga has been removed and replaced with the initials 'JH'."
	icon = 'code/modules/wrestlemania/icons/items/clothing.dmi'
	wear_image_icon = 'code/modules/wrestlemania/icons/mob/clothing.dmi'
	icon_state = "hunter_suit"
	item_state = "hunter_suit"

/obj/item/clothing/mask/gas/hunter
	desc = "There are visible scratches on the top of the mask, suggesting it's visor was forcibly removed."
	icon = 'code/modules/wrestlemania/icons/items/clothing.dmi'
	wear_image_icon = 'code/modules/wrestlemania/icons/mob/clothing.dmi'
	icon_state = "hunter_mask"
	item_state = "hunter_mask"

/obj/item/clothing/gloves/swat/hunter
	desc = "A pair of orange gloves for hand safety and added grip to help hold items."
	icon = 'code/modules/wrestlemania/icons/items/clothing.dmi'
	wear_image_icon = 'code/modules/wrestlemania/icons/mob/hands.dmi'
	icon_state = "hunter_gloves"
	item_state = "hunter_gloves"
