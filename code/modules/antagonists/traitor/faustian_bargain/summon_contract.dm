/datum/targetable/faustian/summon_contract
	icon_state = "clairvoyance" //todo
	name = "Summon Contract and Pen"
	desc = "Spend some souls to acquire a new contract and pen."
	targeted = 0
	pointCost = 2
	cooldown = 60 SECONDS

	cast(mob/target)
		if (!holder)
			return 1
		var/mob/living/M = holder.owner
		if (!M)
			return 1
		if (holder.points < pointCost)
			boutput(M, SPAN_ALERT("You don't have enough souls in your satanic bank account to buy another contract!"))
			boutput(M, SPAN_ALERT("You need [pointCost] souls to afford a contract!"))
			return 1
		if (!isdiabolical(M))
			boutput(M, SPAN_ALERT("You aren't evil enough to use this power!"))
			boutput(M, SPAN_ALERT("Also, you should probably contact a coder because something has gone horribly wrong."))
			return 1
		. = ..()

		var/tempcontract = pick(weakcontracts)
		var/obj/item/contract/U = new tempcontract(M)
		M.put_in_hand_or_drop(U)
		var/obj/item/pen/fancy/faustian/P = new /obj/item/pen/fancy/faustian()
		M.put_in_hand_or_drop(P)
		var/mob/living/carbon/human/H = null
		if (ishuman(M))
			H = M
		if (H && (H.limbs.l_arm || H.limbs.r_arm))
			H.emote("snap", 1)
			H.visible_message(SPAN_ALERT("[H] snaps their fingers and with a puff of smoke a red pen and contract immediatly manifests in their hand."),
			SPAN_NOTICE("You snap your fingers and effortlessly summon a new pen and contract."))
		else
			M.visible_message(SPAN_ALERT("[M] smirks and summons a very sharp red pen and a contract from nothing."),
			SPAN_NOTICE("You effortlessly summon a new pen and contract."))
		return
