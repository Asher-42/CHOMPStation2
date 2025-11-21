/obj/item/capture_crystal/cheap/soulgem_necklace
	name = "Soulgem Necklace"
	desc = "A silent, unassuming crystal in what appears to be some kind of steel housing. This one seems to be cheaply made and can only handle a willing mind."
	icon = 'modular_chomp/icons/inventory/accessory/item.dmi'
	icon_state = "inactive" //not worn one
	empty_icon = "empty"
	full_icon = "full"
	slot_flags = SLOT_MASK //works
	var/slot = ACCESSORY_SLOT_TIE //works
	icon_override = 'modular_chomp/icons/inventory/accessory/mob.dmi'
	item_state = "soulnecklace_m" //works

/datum/gear/accessory/soulgem_necklace
	display_name = "soulgem necklace"
	description = "A shiny steel chain with a vague gemstone."
	path = /obj/item/capture_crystal/cheap/soulgem_necklace

/obj/item/capture_crystal/cheap/soulgem_necklace/capture(mob/living/M, mob/living/U)
	if(!M.capture_crystal || M.capture_caught)
		to_chat(U, span_warning("This creature is not suitable for capture with this crystal."))
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	knowyoursignals(M, U)
	if(isanimal(M) || !M.client)
		to_chat(U, span_warning("This creature is not suitable for capture."))
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	owner = U
	if(!bound_mob)
		bound_mob = M
		bound_mob.capture_caught = TRUE
		persist_storable = FALSE
	desc = "A silent, unassuming crystal in what appears to be some kind of steel housing. This one seems to be cheaply made and can only handle a willing mind."


/obj/item/capture_crystal/cheap/soulgem_necklace/activate(mob/living/user, target)
	if(!cooldown_check())		//Are we ready to do things yet?
		to_chat(thrower, span_notice("\The [src] clicks unsatisfyingly... It is not ready yet."))
		playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		return
	if(spawn_mob_type && !bound_mob)			//We don't already have a mob, but we know what kind of mob we want
		bound_mob = new spawn_mob_type(src)		//Well let's spawn it then!
		bound_mob.faction = user.faction
		spawn_mob_type = null
		capture(bound_mob, user)
	if(bound_mob)								//We have a mob! Let's finish setting up.
		user.visible_message("\The [src] clicks, and then emits a small chime.", "\The [src] grows warm in your hand, something inside is awake.")
		active = TRUE
		if(!owner)								//Do we have an owner? It's pretty unlikely that this would ever happen! But it happens, let's claim the crystal.
			owner = user
			if(isanimal(bound_mob))
				var/mob/living/simple_mob/S = bound_mob
				S.revivedby = user.name
		determine_action(user, target)
		return
	else if(isliving(target))						//So we don't have a mob, let's try to claim one! Is the target a mob?
		var/mob/living/M = target
		last_activate = world.time
		if(M.capture_caught)					//Can't capture things that were already caught.
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, span_notice("\The [src] clicks unsatisfyingly... \The [M] is already under someone else's control."))
			return
		else if(M.stat == DEAD)						//Is it dead? We can't influence dead things.
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, span_notice("\The [src] clicks unsatisfyingly... \The [M] is not in a state to be captured."))
			return
		else if(M.client)							//Is it player controlled?
			capture_player(M, user)				//We have to do things a little differently if so.
			return
		else if(!isanimal(M))						//So it's not player controlled, but it's also not a simplemob?
			to_chat(user, span_warning("This creature is not suitable for capture."))
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/mob/living/simple_mob/S = M
		if(!S.ai_holder)						//We don't really want to capture simplemobs that don't have an AI
			to_chat(user, span_warning("This creature is not suitable for capture."))
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
		else									//Shoot, it didn't work and now it's mad!!!
			S.ai_holder.go_wake()
			S.ai_holder.give_target(user, urgent = TRUE)
			user.visible_message("\The [src] bonks into \the [S], angering it!")
			playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, span_notice("\The [src] clicks unsatisfyingly."))
		update_icon()
		return
	//The target is not a mob, so let's not do anything.
	playsound(src, 'sound/effects/capture-crystal-negative.ogg', 75, 1, -1)
	to_chat(user, span_notice("\The [src] clicks unsatisfyingly."))
