/obj/item/pen/fancy/faustian
	name = "demonic pen"
	desc = "A pen once owned by Old Nick himself. The point is as sharp as the Devil's wit, so it makes an excellent improvised throwing or stabbing weapon."
	force = 10
	throwforce = 10
	throw_range = 20
	burn_possible = FALSE
	hit_type = DAMAGE_STAB
	color = "#FF0000"
	font_color = "#FF0000"
	HELP_MESSAGE_OVERRIDE({"Use the pen on a contract to write up a new contract or to erase it. Throw the pen for a guaranteed stun.
							This pen does increased damage against anyone who has signed a contract, scaling greatly with how corrupted their soul is."})

	throw_impact(atom/A, datum/thrown_thing/thr)
		if(iscarbon(A))
			var/mob/living/carbon/C = A
			C:lastattacker = usr
			C:lastattackertime = world.time
			if (C.mind?.soul < 100)
				var/soul_multiplier = C.mind.soul / 100
				//Up to 8 more bleed and 8 additional brute and burn
				take_bleeding_damage(C, null, (8 - round(8 * soul_multiplier)), DAMAGE_STAB)
				random_brute_damage(C, 1 + (7 - round(7 * soul_multiplier)))
				random_burn_damage(C, 1 + (7 - round(7 * soul_multiplier)))
				C.changeStatus("knockdown", (3.5 SECONDS + (4 - round(4 * soul_multiplier)))) // 3.5 second baseline, scaling up to a maximum of 6.5 seconds at max sin
				boutput(C, SPAN_ALERT("The pen lodges itself into your flesh, searing it! Your mind goes blank for a moment!"))
			else
				C.changeStatus("knockdown", (3.5 SECONDS))
			take_bleeding_damage(C, null, 15, DAMAGE_STAB)
		..()

	attack(target, mob/user)
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			playsound(C, 'sound/impact_sounds/Flesh_Stab_1.ogg', 60, TRUE)
			if(!isdead(C))
				if (C.mind?.soul < 100)
					var/soul_multiplier = C.mind.soul / 100
					//Up to 6 more bleed and 6 additional brute and burn
					take_bleeding_damage(C, null, (6 - round(6 * soul_multiplier)), DAMAGE_STAB)
					random_brute_damage(C, 1 + (5 - round(5 * soul_multiplier)))
					random_burn_damage(C, 1 + (5 - round(5 * soul_multiplier)))
					boutput(C, SPAN_ALERT("The pen feels unnaturally sharp! It's like it's seeking out the most painful possibly place to strike!"))
				take_bleeding_damage(C, user, 15, DAMAGE_STAB)
		..()

/obj/item/storage/box/faustian // the one you get in your briefcase
	name = "box of demonic pens"
	desc = "A box adequately sized for any demonic pens, great for collectors."
	spawn_contents = list(/obj/item/pen/fancy/faustian = 4)
	burn_possible = FALSE

/obj/item/paper/faustian_bargain_kit
	color = "#FF0000"
	name = "Paper-'Soul Stealing 101'"
	burn_possible = FALSE
	info = {"<b>You shouldn't be seeing this yet!</b>"}

	New()
		..()
		//Todo rewrite this
		info = {"<center><b>SO YOU WANT TO STEAL SOULS?</b></center><ul>
			<li>Step One: Grab a complimentary extra-sharp demonic pen and your infernal contract of choice from your devilish briefcase.</li>
			<li>Step Two: Present your contract to your victim by clicking on them with said contract, but be sure you have your hellish writing utensil handy in your other hand!</li>
			<li>Step Three: It takes about four seconds for you to force your victim to sign their name, be sure not to move during this process or the ink will smear!</li></ul>
			<b>Alternatively, you can just have people sign the contract willingly, but where's the fun in that?</b>
			<li>Your contracts are written in legalese, so anyone not wearing your lawyer suit is unable to read them!</li>
			<li>Your lawyer suit, in addition to looking stylish, doubles as a suit of body armor. Similarly, your briefcase is a great bludgeoning tool, and your pens make excellent throwing daggers.</li>
			<li>As you collect more souls, your briefcase and pens will grow stronger and will gain unique powers.</li>
			<li>You can expend [CONTRACT_COST] collected souls to summon another major contract, but your weapons will weaken as a result.</li>
			<li>To do so, click on the Summon Contract ability under the tab labeled Souls. Alternatively, right click on your briefcase while holding it in your hand and then select the option labelled Summon Contract.</li>
			<b><li>Oh, and if you ever find something that talks about horses, use it in your hand. Just trust your old pal Nick on this one.</li></b>"}


/obj/item/storage/briefcase/faustian
	name = "devilish briefcase"
	color = "#FF0000"
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 8
	burn_possible = FALSE
	item_function_flags = IMMUNE_TO_ACID
	desc = "A diabolical human leather-bound briefcase, capable of holding a number of small objects and tormented souls."
	stamina_damage = 70
	stamina_cost = 15
	stamina_crit_chance = 30
	spawn_contents = list(/obj/item/paper/faustian_bargain_kit,
							/obj/item/storage/box/faustian,
							/obj/item/clothing/under/misc/lawyer/red/demonic,
							/obj/item/faustian_contract/blank,
							/obj/item/faustian_contract/blank,
							/obj/item/faustian_contract/blank)
	var/faustian_key = null
	HELP_MESSAGE_OVERRIDE({"The briefcase deals improved damage to anyone who has signed a contract, scaling greatly with how corrupted their soul is.
							When a contract has been used up a new one will spawn inside this briefcase."})

	New()
		. = ..()
		START_TRACKING

	disposing()
		. = ..()
		STOP_TRACKING

	attack(mob/target, mob/user, def_zone, is_special = FALSE, params = null)
		..()
		if (target.mind && target.mind.soul < 100)
			var/soul_multiplier = target.mind.soul / 100
			random_burn_damage(target, 8 - round(8 * soul_multiplier)) //Wacking someone over the head will do some burn damage, scaling with their accumulated sin.
			if (target.mind.soul <= 50 && isliving(target))
				var/mob/living/L = target
				L.update_burning(12 - round(12 * soul_multiplier)) //sets people on fire if the target is a little sinful. Scales with their sin.
			if (target.mind.soul <= 0)
				wrestler_backfist(user, target) //sends people flying if they are very sinful.

	proc/set_faustian_owner(mob/M)
		src.faustian_key = M.mind?.key
		for (var/obj/item/faustian_contract/contract in src.storage.get_contents())
			contract.faustian_key = M.mind?.key

ABSTRACT_TYPE(/obj/item/faustian_contract)
/obj/item/faustian_contract
	name = "faustian contract parent"
	desc = "This should never be seen"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll_seal"
	inhand_image_icon = 'icons/mob/inhand/hand_books.dmi'
	item_state = "paper"
	color = "#FF0000"
	throw_speed = 4
	throw_range = 10
	flags = TABLEPASS
	w_class = W_CLASS_SMALL
	burn_possible = FALSE //Only makes sense since it's from hell.
	var/faustian_key = null
	HELP_MESSAGE_OVERRIDE({"Use your demonic pen on the contract to write a new contract.
							Use the written contract on a human with your demonic pen in the other hand to force them to sign it.
							They may also sign the contract by themselves by using the pen on the contract.
							Contracts with no drawbacks quickly corrupts the person's soul. Contracts with a small drawback corrupt slower. Contracts with no benefits generate very little corruption."})

/*
	examine(mob/user)
		if ((ishuman(user) && istype(user:w_uniform, /obj/item/clothing/under/misc/lawyer/red/demonic)) || isobserver(user))
			return ..()
		else
			return list("A strange piece of old crinkled paper, covered in mysterious gibberish legalese.")
		proc/MagicEffect(var/mob/user as mob, var/mob/badguy as mob) //this calls the actual contract effect
		if (!user)
			return 0
		if (isdiabolical(user))
			boutput(user, SPAN_NOTICE("You can't sell your soul to yourself!"))
			return 0
		boutput(user, SPAN_ALERT(SPAN_BOLD("The pen stabs into your hand as you start to sign, your blood trickling down onto the page.")))
		src.visible_message(SPAN_ALERT("<b>[user] signs [his_or_her(user)] name in [his_or_her(user)] own blood upon [src]!</b>"))
		take_bleeding_damage(user, user, 4, DAMAGE_STAB, TRUE)
		logTheThing(LOG_ADMIN, user, "signed a [src.type] contract at [log_loc(user)]!")
		. = user.sell_soul(100, 0, 1)
		if(!.)
			boutput(badguy, "[user] signed [src] but had no soul to give!")
*/
	proc/vanish(var/mob/user, var/mob/badguy)
		if(user)
			boutput(user, SPAN_NOTICE("<b>The depleted contract vanishes in a puff of smoke!</b>"))
		playsound(src.loc, pick('sound/voice/creepywhisper_1.ogg', 'sound/voice/creepywhisper_2.ogg', 'sound/voice/creepywhisper_3.ogg'), 50, 1)
		SPAWN(1 DECI SECOND)
			qdel(src)

	attack(mob/target, mob/user, def_zone, is_special = FALSE, params = null)
		if (!isliving(target) || isghostdrone(target) || issilicon(target) || isintangible(target))
			return
		if (!user.find_type_in_hand(/obj/item/pen/fancy/faustian))
			return
		else if (isdiabolical(user))
			if (isnpc(target))
				boutput(user, SPAN_NOTICE("They don't have a soul to sell!"))
				return
			if (target == user)
				boutput(user, SPAN_NOTICE("You can't sell your soul to yourself!"))
				return
			if (isdead(target))
				boutput(user, SPAN_NOTICE("They are dead, you can't sell their soul now!"))
				return
			if (!target.literate)
				// 'they' has to exist
				boutput(user, SPAN_NOTICE("Unfortunately [he_or_she_dont_or_doesnt(target)] know how to write. [capitalize(his_or_her(target))] signature will mean nothing."))
				return
			if (ismobcritter(target))
				var/mob/living/critter/C = target
				if (C.is_npc)
					boutput(user, SPAN_NOTICE("Despite your best efforts [target] refuses to sell you [his_or_her(target)] soul!"))
					return
			if (target.mind?.soul_claimed)
				boutput(user, SPAN_NOTICE("You have already claimed this one's soul. There is no reason to give them a contract. No free handouts."))
				return
		/*
			Todo increment contracts signed on mind
			Reset sin also for contract stacking

			if (src.inuse != 1)
				actions.start(new/datum/action/bar/icon/force_sign(user, target, src), user)
*/

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/pen))
			if (user.mind?.soul_claimed)
				boutput(user, SPAN_NOTICE("The contract rejects you. It asks for a soul but you have none to give."))
				return
			if (isdiabolical(user))
				boutput(user, SPAN_NOTICE("You can't sell your soul to yourself!"))
				return
			else if (!isliving(user) || isghostdrone(user) || issilicon(user))
				return
			else if (istype(W, /obj/item/pen/fancy/faustian))
				//MagicEffect(user, src.merchant)
				return
			else
				user.visible_message(SPAN_ALERT("<b>[user] looks puzzled as [he_or_she(user)] realizes [his_or_her(user)] pen isn't evil enough to sign [src]!</b>"))
				return

/obj/item/faustian_contract/blank
