//luminous aether stuff
/datum/bioEffect/glittery
	name = "Covered in rainbow glitter"
	desc = "You are covered in glitter from head to toe. Anyone standing near you will be rapidly covered in rainbow colors. And also incredibly itchy."
	id = "glittery"
	effectType = EFFECT_TYPE_DISABILITY
	isBad = 1
	msgGain = "You feel sticky!"
	msgLose = "You feel a lot cleaner. And also less fashionable."

	OnLife(var/mult)
		if(..()) return
		for(var/mob/living/carbon/C in view(4,get_turf(owner)))
			if (C == owner)
				continue
			else
				if (prob(15))
					switch (pick(1, 2, 3))
						if (1)
							C.emote(pick("cough", "wheeze", "mumble", "sneeze"))
							boutput(C, "<span class='alert'>You inhale some glitter! You feel awful and sticky!</span>")
						if (2)
							C.emote(pick("blink_r", "blink"))
							C.change_eye_blurry(2)
							boutput(C, "<span class='alert'>Some glitter gets in your eyes! It burns!</span>")
						if (3)
							C.emote("gasp")
							C.reagents.add_reagent("glitter", 5)
							boutput(C, "<span class='alert'>You can taste glitter on your tongue! This stuff is getting <b>EVERYWHERE</b></span>")

/datum/bioEffect/power/bigpuke/glitterpuke
	name = "Glittery Mass Emesis"
	id = "acid_bigpuke"
	ability_path = /datum/targetable/geneticsAbility/bigpuke/glitter
	cooldown = 20 SECONDS
