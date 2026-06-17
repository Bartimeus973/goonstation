/datum/targetable/faustian/claim_soul
	name = "Claim soul"
	icon_state = "clairvoyance"
	desc = "Collect your due from a dead human who has signed a contract before!"
	targeted = 1
	target_anything = 1
	cooldown = 3 SECONDS

	cast(atom/target)
		if (..())
			return 1
		if (!holder || !istype(holder, /datum/abilityHolder/faustian))
			return 1
		var/datum/abilityHolder/faustian/faustian_holder = holder
		var/mob/living/owner = faustian_holder.owner
		if (!owner)
			return 1
		if (!target)
			target = get_turf(faustian_holder.owner)

		var/mob/living/carbon/human/H = null
		if (ishuman(target))
			H = target
		if (isturf(target))
			for (var/mob/living/carbon/human/mob_target in target.contents)
				if (!isdead(mob_target))
					continue
				H = mob_target
				break

		if (!H)
			boutput(SPAN_ALERT("There is no one here."))

		if (!isdead(H))
			boutput(faustian_holder.owner, SPAN_ALERT("This human isn't dead yet. Perhaps you should hasten their demise."))
			return 1

		var/datum/mind/mind_to_claim
		if (H.mind)
			mind_to_claim = H.mind
		else if (H.client && H.client.mob && H.client.mob.mind)
			mind_to_claim = H.client.mob.mind
		else if (H.ghost && (H.ghost.mind || H.ghost.client))
			var/mob/dead/ghost = H.ghost
			if(ghost.mind)
				mind_to_claim = ghost.mind
			else if (ghost.client)
				mind_to_claim = ghost.client.mob.mind
		else if (H.last_client)
			for (var/client/C in clients)
				if (C == H.last_client && C.mob && (isobserver(C.mob) || isVRghost(C.mob)))
					if(C.mob && C.mob.mind)
						mind_to_claim = C.mob.mind
						break

		if (!mind_to_claim)
			boutput(owner, SPAN_ALERT("There is no mind here, no sin to collect."))
			return 1
		if (mind_to_claim.soul >= 100)
			boutput(owner, SPAN_ALERT("This human soul isn't corrupted."))
			return 1
		if (mind_to_claim.soul_claimed)
			boutput(owner, SPAN_ALERT("This corpse has no soul lingering within, it has already been claimed. Hopefully by you."))
			return 1

		boutput(owner, SPAN_ALERT("You send this human's soul to the deepest layers of hell. Your demonic powers grow."))
		playsound(H, "sound/voice/wraith/wraithsoulsucc[rand(1, 2)].ogg", 30, 0)
		faustian_holder.points += 1
		faustian_holder.soul_power += (100 - mind_to_claim.soul) * mind_to_claim.contracts_signed
		mind_to_claim.soul_claimed = TRUE
		if (mind_to_claim.soul > 70)
			boutput(owner, SPAN_ALERT("This soul wasn't very corrupted yet, but it will suffice. It is best to let someone indulge in their sin for a while before claiming their soul."))
		else if (mind_to_claim.soul > 30)
			boutput(owner, SPAN_ALERT("An acceptably sinful soul. You feel glee knowing the unending torment they will face in the depths below."))
		else
			boutput(owner, SPAN_ALERT("What a deliciously wretched soul! They reveled and wallowed in their sinful nature until the time was right for the reaping."))

		//Your devilish rewards
		if (faustian_holder.soul_power > 150 && !owner.bioHolder.HasEffect("strong"))
			boutput(owner, SPAN_ALERT("The ones watching from below see great potential in you. They lend you a mote of their power."))
			owner.bioHolder.AddEffect("strong", magical = TRUE)

		if (faustian_holder.soul_power >= 400)
			boutput(owner, SPAN_ALERT("Such a devilish salesperson should look as fiendish on the outside as they feel on the inside."))
			if (!owner.bioHolder.HasEffect("demon_horns"))
				owner.bioHolder.AddEffect("demon_horns", 0, 0, 1)
			if (!owner.bioHolder.HasEffect("hell_fire"))
				owner.bioHolder.AddEffect("hell_fire", 0, 0, 1)
		else
			if (owner.bioHolder.HasEffect("demon_horns"))
				owner.bioHolder.RemoveEffect("demon_horns", 0, 0, 1)
			if (owner.bioHolder.HasEffect("hell_fire"))
				owner.bioHolder.RemoveEffect("hell_fire", 0, 0, 1)

		if (faustian_holder.soul_power >= 650 && !owner.bioHolder.HasEffect("hulk_hidden"))
			boutput(owner, SPAN_ALERT("The big man downstairs has noticed you. Do not disappoint him."))
			owner.bioHolder.AddEffect("hulk_hidden", magical = TRUE)

		return 0
