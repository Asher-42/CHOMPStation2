/datum/artifact_effect/badfeeling
	name = "badfeeling"
	effect_type = EFFECT_PSIONIC
	var/list/messages = list("You feel worried.",
		"Something doesn't feel right.",
		"You get a strange feeling in your gut.",
		"Your instincts are trying to warn you about something.",
		"Someone just walked over your grave.",
		"There's a strange feeling in the air.",
		"There's a strange smell in the air.",
		"The tips of your fingers feel tingly.",
		"You feel witchy.",
		"You have a terrible sense of foreboding.",
		"You've got a bad feeling about this.",
		"Your scalp prickles.",
		"The light seems to flicker.",
		"The shadows seem to lengthen.",
		"The walls are getting closer.",
		"Something is wrong")

	var/list/drastic_messages = list("You've got to get out of here!",
		"Someone's trying to kill you!",
		"There's something out there!",
		"What's happening to you?",
		"OH GOD!",
		"HELP ME!")

	effect_state = "summoning"
	effect_color = "#643232"

/datum/artifact_effect/badfeeling/DoEffectTouch(var/mob/user)
	if(user)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if(prob(50))
				if(prob(75))
					to_chat(H, span_red(span_bold("<font size='[num2text(rand(1,5))]'>[pick(drastic_messages)]") + "</font>"))
				else
					to_chat(H, span_red("[pick(messages)]"))

			if(prob(50))
				H.dizziness += rand(3,5)

/datum/artifact_effect/badfeeling/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(5))
				if(prob(75))
					to_chat(H, span_red("[pick(messages)]"))
				else
					to_chat(H, span_red("<font size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>"))

			if(prob(10))
				H.dizziness += rand(3,5)
		return 1

/datum/artifact_effect/badfeeling/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(50))
				if(prob(95))
					to_chat(H, span_red("<font size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>"))
				else
					to_chat(H, span_red("[pick(messages)]"))

			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
		return 1
