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
		if (!holder)
			return 1
		var/mob/living/owner = holder.owner
		if (!owner)
			return 1
		if (!target)
			target = get_turf(holder.owner)

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
			boutput(holder.owner, SPAN_ALERT("This human isn't dead yet. Perhaps you should hasten their demise."))
			return 1

		var/datum/mind/mind_to_claim
		if (H.mind)
			mind_to_claim = H.mind
		else if (H.client)
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
		if (mind_to_claim.soul_claimed)
			boutput(owner, SPAN_ALERT("This corpse has no soul lingering within, it has already been claimed. Hopefully by you."))

		boutput(owner, SPAN_ALERT("You send this human's soul to the deepest layers of hell. Your demonic powers grow."))
		playsound(H, "sound/voice/wraith/wraithsoulsucc[rand(1, 2)].ogg", 30, 0)
		holder.points += 1
		mind_to_claim.soul_claimed = TRUE
		return 0
