/datum/abilityHolder/faustian
	usesPoints = 0
	regenRate = 0
	pointName = "Souls"
	notEnoughPointsMessage = SPAN_ALERT("You need more souls to use this ability!")

	onAbilityStat() // In the "Souls" tab.
		..()
		.= list()
		.["Souls:"] = src.points
		return

/atom/movable/screen/ability/topBar/faustian
//Possibly remove all this?
	clicked(params)
		var/datum/targetable/faustian/spell = owner
		if (!istype(spell))
			return
		if (!spell.holder)
			return
		if (!isturf(owner.holder.owner.loc))
			boutput(owner.holder.owner, SPAN_ALERT("You can't use this ability here."))
			return
		if (spell.targeted && usr.targeting_ability == owner)
			usr.targeting_ability = null
			usr.update_cursor()
			return
		if (spell.targeted)
			if (world.time < spell.last_cast)
				return
			owner.holder.owner.targeting_ability = owner
			owner.holder.owner.update_cursor()
		else
			SPAWN(0)
				spell.handleCast()
		return

/mob/proc/make_faustian()
	if (ishuman(src))
		var/datum/abilityHolder/faustian/A = src.get_ability_holder(/datum/abilityHolder/faustian)
		if (A && istype(A))
			return
		var/datum/abilityHolder/faustian/W = src.add_ability_holder(/datum/abilityHolder/faustian)
		W.addAbility(/datum/targetable/faustian/summon_briefcase)
		W.addAbility(/datum/targetable/faustian/summon_contract)
		W.addAbility(/datum/targetable/faustian/locate_soul)
		W.addAbility(/datum/targetable/faustian/claim_soul)
		if (src.mind)
			if (!isdiabolical(src))
				src.mind.diabolical = 1

/datum/targetable/faustian
	icon = 'icons/mob/spell_buttons.dmi'
	icon_state = "template"
	cooldown = 0
	last_cast = 0
	pointCost = 0
	preferred_holder_type = /datum/abilityHolder/faustian
	var/when_stunned = 0 // 0: Never | 1: Ignore mob.stunned and mob.weakened | 2: Ignore all incapacitation vars
	var/not_when_handcuffed = 0

	New()
		var/atom/movable/screen/ability/topBar/faustian/B = new /atom/movable/screen/ability/topBar/faustian(null)
		B.icon = src.icon
		B.icon_state = src.icon_state
		B.owner = src
		B.name = src.name
		B.desc = src.desc
		src.object = B

	updateObject()
		..()
		if (!src.object)
			src.object = new /atom/movable/screen/ability/topBar/faustian()
			object.icon = src.icon
			object.owner = src
		if (src.last_cast > world.time)
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt] ([round((src.last_cast-world.time)/10)])"
			object.icon_state = src.icon_state + "_cd"
		else
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt]"
			object.icon_state = src.icon_state
		return

	proc/incapacitation_check(var/stunned_only_is_okay = 0)
		if (!holder)
			return 0

		var/mob/living/M = holder.owner
		if (!M || !ismob(M))
			return 0

		switch (stunned_only_is_okay)
			if (0)
				if (!isalive(M) || M.hasStatus(list("stunned", "unconscious", "knockdown")))
					return 0
				else
					return 1
			if (1)
				if (!isalive(M) || M.getStatusDuration("unconscious") > 0)
					return 0
				else
					return 1
			else
				return 1

	castcheck()
		if (!holder)
			return 0

		var/mob/living/M = holder.owner

		if (!M)
			return 0

		if (!ishuman(M))
			boutput(M, SPAN_ALERT("You cannot use any powers in your current form."))
			return 0

		if (M.transforming)
			boutput(M, SPAN_ALERT("You can't use any powers right now."))
			return 0

		if (incapacitation_check(src.when_stunned) != 1)
			boutput(M, SPAN_ALERT("You can't use this ability while incapacitated!"))
			return 0

		if (src.not_when_handcuffed == 1 && M.restrained())
			boutput(M, SPAN_ALERT("You can't use this ability when restrained!"))
			return 0

		if (!(isdiabolical(M)))
			boutput(M, SPAN_ALERT("You aren't evil enough to use this power!"))
			boutput(M, SPAN_ALERT("Also, you should probably contact a coder because something has gone horribly wrong."))
			return 0

		return 1

	cast(atom/target)
		. = ..()
		actions.interrupt(holder.owner, INTERRUPT_ACT)
		return
