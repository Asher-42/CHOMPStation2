#define FARMBOT_COLLECT 1
#define FARMBOT_WATER 2
#define FARMBOT_UPROOT 3
#define FARMBOT_NUTRIMENT 4

/mob/living/bot/farmbot
	name = "Farmbot"
	desc = "The botanist's best friend."
	icon = 'icons/obj/chemical_tanks.dmi'
	icon_state = "farmbot0"
	health = 50
	maxHealth = 50
	req_one_access = list(access_robotics, access_hydroponics, access_xenobiology)

	var/action = "" // Used to update icon
	var/waters_trays = 1
	var/refills_water = 1
	var/uproots_weeds = 1
	var/replaces_nutriment = 0
	var/collects_produce = 0
	var/removes_dead = 0
	var/times_idle = 0 //VOREStation Add
	var/obj/structure/reagent_dispensers/watertank/tank


/mob/living/bot/farmbot/Initialize(mapload, var/newTank)
	. = ..()
	if(!newTank)
		newTank = new /obj/structure/reagent_dispensers/watertank(src)
	tank = newTank
	tank.forceMove(src)

/mob/living/bot/farmbot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Farmbot", name)
		ui.open()

/mob/living/bot/farmbot/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["on"] = on
	data["tank"] = !!tank
	if(tank)
		data["tankVolume"] = tank.reagents.total_volume
		data["tankMaxVolume"] = tank.reagents.maximum_volume
	data["locked"] = locked

	data["waters_trays"] = null
	data["refills_water"] = null
	data["uproots_weeds"] = null
	data["replaces_nutriment"] = null
	data["collects_produce"] = null
	data["removes_dead"] = null

	if(!locked)
		data["waters_trays"] = waters_trays
		data["refills_water"] = refills_water
		data["uproots_weeds"] = uproots_weeds
		data["replaces_nutriment"] = replaces_nutriment
		data["collects_produce"] = collects_produce
		data["removes_dead"] = removes_dead

	return data


/mob/living/bot/farmbot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	tgui_interact(user)

/mob/living/bot/farmbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, span_notice("You short out [src]'s plant identifier circuits."))
		spawn(rand(30, 50))
			visible_message(span_warning("[src] buzzes oddly."))
			emagged = 1
		return 1

/mob/living/bot/farmbot/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("power")
			if(!access_scanner.allowed(ui.user))
				return FALSE
			if(on)
				turn_off()
			else
				turn_on()
			. = TRUE

	if(locked)
		return TRUE

	switch(action)
		if("water")
			waters_trays = !waters_trays
			. = TRUE
		if("refill")
			refills_water = !refills_water
			. = TRUE
		if("weed")
			uproots_weeds = !uproots_weeds
			. = TRUE
		if("replacenutri")
			replaces_nutriment = !replaces_nutriment
			. = TRUE
		// VOREStation Edit: No automatic hydroponics
		// if("collect")
		// 	collects_produce = !collects_produce
		// 	. = TRUE
		// if("removedead")
		// 	removes_dead = !removes_dead
		// 	. = TRUE
		// VOREStation Edit End


/mob/living/bot/farmbot/update_icons()
	if(on && action)
		icon_state = "farmbot_[action]"
	else
		icon_state = "farmbot[on]"

/mob/living/bot/farmbot/handleRegular()
	if(emagged && prob(1))
		flick("farmbot_broke", src)

/mob/living/bot/farmbot/handleAdjacentTarget()
	UnarmedAttack(target)

/mob/living/bot/farmbot/lookForTargets()
	if(emagged)
		for(var/mob/living/carbon/human/H in view(7, src))
			target = H
			times_idle = 0 //VOREStation Add - Idle shutoff time
			return
	else
		for(var/obj/machinery/portable_atmospherics/hydroponics/tray in view(7, src))
			if(confirmTarget(tray))
				target = tray
				times_idle = 0 //VOREStation Add - Idle shutoff time
				return
		if(!target && refills_water && tank && tank.reagents?.total_volume < tank.reagents.maximum_volume) // ChompEDIT - runtime
			for(var/obj/structure/sink/source in view(7, src))
				target = source
				times_idle = 0 //VOREStation Add - Idle shutoff time
				return
	if(++times_idle == 150) turn_off() //VOREStation Add - Idle shutoff time

/mob/living/bot/farmbot/calcTargetPath() // We need to land NEXT to the tray, because the tray itself is impassable
	if(isnull(target))
		return
	target_path = SSpathfinder.default_bot_pathfinding(src, get_turf(target), 1, 32) //CHOMPEdit
	if(!target_path)
		ignore_list |= target
		target = null
		target_path = list()
	return

/mob/living/bot/farmbot/stepToTarget() // Same reason
	var/turf/T = get_turf(target)
	if(!target_path.len || !T.Adjacent(target_path[target_path.len]))
		calcTargetPath()
	makeStep(target_path)
	return

/mob/living/bot/farmbot/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	if(busy)
		return

	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = A

		var/t = confirmTarget(T)
		switch(t)
			if(0)
				return
			if(FARMBOT_COLLECT)
				action = "water" // Needs a better one
				update_icons()
				visible_message(span_notice("[src] starts [T.dead? "removing the plant from" : "harvesting"] \the [A]."))

				busy = 1
				if(do_after(src, 30, A))
					visible_message(span_notice("[src] [T.dead? "removes the plant from" : "harvests"] \the [A]."))
					T.attack_hand(src)
			if(FARMBOT_WATER)
				action = "water"
				update_icons()
				visible_message(span_notice("[src] starts watering \the [A]."))

				busy = 1
				if(do_after(src, 30, A))
					playsound(src, 'sound/effects/slosh.ogg', 25, 1)
					visible_message(span_notice("[src] waters \the [A]."))
					tank.reagents.trans_to(T, 100 - T.waterlevel)
			if(FARMBOT_UPROOT)
				action = "hoe"
				update_icons()
				visible_message(span_notice("[src] starts uprooting the weeds in \the [A]."))

				busy = 1
				if(do_after(src, 30))
					visible_message(span_notice("[src] uproots the weeds in \the [A]."))
					T.weedlevel = 0
			if(FARMBOT_NUTRIMENT)
				action = "fertile"
				update_icons()
				visible_message(span_notice("[src] starts fertilizing \the [A]."))

				busy = 1
				if(do_after(src, 30, A))

					visible_message(span_notice("[src] fertilizes \the [A]."))
					T.reagents.add_reagent(REAGENT_ID_AMMONIA, 10)

		busy = 0
		action = ""
		update_icons()
		T.update_icon()
	else if(istype(A, /obj/structure/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return
		action = "water"
		update_icons()
		visible_message(span_notice("[src] starts refilling its tank from \the [A]."))

		busy = 1
		while(do_after(src, 10) && tank.reagents.total_volume < tank.reagents.maximum_volume)
			tank.reagents.add_reagent("water", 100) //VOREStation Edit
			if(prob(5))
				playsound(src, 'sound/effects/slosh.ogg', 25, 1)

		busy = 0
		action = ""
		update_icons()
		visible_message(span_notice("[src] finishes refilling its tank."))
	else if(emagged && ishuman(A))
		var/action = pick("weed", "water")

		busy = 1
		spawn(50) // Some delay

			busy = 0
		switch(action)
			if("weed")
				flick("farmbot_hoe", src)
				do_attack_animation(A)
				if(prob(50))
					visible_message(span_danger("[src] swings wildly at [A] with a minihoe, missing completely!"))
					return
				var/t = pick("slashed", "sliced", "cut", "clawed")
				A.attack_generic(src, 5, t)
			if("water")
				flick("farmbot_water", src)

				visible_message(span_danger("[src] splashes [A] with water!"))
				tank.reagents.splash(A, 100)

/mob/living/bot/farmbot/explode()
	visible_message(span_danger("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/material/minihoe(Tsec)
	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	new /obj/item/analyzer/plant_analyzer(Tsec)

	if(tank)
		tank.loc = Tsec

	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	//qdel(src)
	return ..()


/mob/living/bot/farmbot/confirmTarget(var/atom/targ)
	if(!..())
		return 0

	if(emagged && ishuman(targ))
		if(targ in view(world.view, src))
			return 1
		return 0

	if(istype(targ, /obj/structure/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return 0
		return 1

	var/obj/machinery/portable_atmospherics/hydroponics/tray = targ
	if(!istype(tray))
		return 0

	if(tray.closed_system || !tray.seed)
		return 0

	if(tray.dead && removes_dead || tray.harvest && collects_produce)
		return FARMBOT_COLLECT

	else if(refills_water && tray.waterlevel < 40 && !tray.reagents.has_reagent("water") && tank.reagents.total_volume > 0)
		return FARMBOT_WATER

	else if(uproots_weeds && tray.weedlevel > 3)
		return FARMBOT_UPROOT

	else if(replaces_nutriment && tray.nutrilevel < 1 && tray.reagents.total_volume < 1)
		return FARMBOT_NUTRIMENT

	return 0

// Assembly

/obj/item/farmbot_arm_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/obj/chemical_tanks.dmi'
	icon_state = "water_arm"
	var/build_step = 0
	var/created_name = "Farmbot"
	var/obj/tank
	w_class = ITEMSIZE_NORMAL


/obj/item/farmbot_arm_assembly/New(var/newloc, var/theTank)
	..(newloc)
	if(!theTank) // If an admin spawned it, it won't have a watertank it, so lets make one for em!
		tank = new /obj/structure/reagent_dispensers/watertank(src)
	else
		tank = theTank
		tank.forceMove(src)

/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/robot_parts/S, mob/user as mob)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		..()
		return


	to_chat(user, "You add the robot arm to [src].")

	user.drop_from_inventory(S)
	qdel(S)

	new /obj/item/farmbot_arm_assembly(loc, src)

/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/organ/external/S, mob/user as mob)
	if ((!istype(S, /obj/item/organ/external/arm)) || S.robotic != ORGAN_ROBOT)
		..()
		return

	to_chat(user, "You add the robot arm to [src].")

	user.drop_from_inventory(S)
	qdel(S)

	new /obj/item/farmbot_arm_assembly(loc, src)

/obj/item/farmbot_arm_assembly/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if((istype(W, /obj/item/analyzer/plant_analyzer)) && (build_step == 0))
		build_step++
		to_chat(user, "You add the plant analyzer to [src].")
		name = "farmbot assembly"

		user.remove_from_mob(W)
		qdel(W)

	else if((istype(W, /obj/item/reagent_containers/glass/bucket)) && (build_step == 1))
		build_step++
		to_chat(user, "You add a bucket to [src].")
		name = "farmbot assembly with bucket"

		user.remove_from_mob(W)
		qdel(W)

	else if((istype(W, /obj/item/material/minihoe)) && (build_step == 2))
		build_step++
		to_chat(user, "You add a minihoe to [src].")
		name = "farmbot assembly with bucket and minihoe"

		user.remove_from_mob(W)
		qdel(W)

	else if((isprox(W)) && (build_step == 3))
		build_step++
		to_chat(user, "You complete the Farmbot! Beep boop.")

		var/mob/living/bot/farmbot/S = new /mob/living/bot/farmbot(get_turf(src), tank)
		S.name = created_name

		user.remove_from_mob(W)
		qdel(W)
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = tgui_input_text(user, "Enter new robot name", name, created_name, MAX_NAME_LEN)
		t = sanitize(t, MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return

		created_name = t

/obj/item/farmbot_arm_assembly/attack_hand(mob/user as mob)
	return //it's a converted watertank, no you cannot pick it up and put it in your backpack

#undef FARMBOT_COLLECT
#undef FARMBOT_WATER
#undef FARMBOT_UPROOT
#undef FARMBOT_NUTRIMENT
