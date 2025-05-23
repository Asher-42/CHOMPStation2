//Most of these are defined at this level to reduce on checks elsewhere in the code.
//Having them here also makes for a nice reference list of the various overlay-updating procs available

/mob/proc/regenerate_icons()		//Update every aspect of the mob's icons (expensive, resist the urge to use unless you need it)
	return

/mob/proc/update_icons()
	update_icon() //Ugh.
	return

// Obsolete
/mob/proc/update_icons_body()
	return
// End obsolete

/mob/proc/update_hud()
	return

/mob/proc/update_inv_handcuffed()
	return

/mob/proc/update_inv_legcuffed()
	return

/mob/proc/update_inv_back()
	return

/mob/proc/update_inv_active_hand()
	return

/mob/living/update_inv_active_hand(var/A)
	if(hand)
		update_inv_l_hand(A)
	else
		update_inv_r_hand(A)

/mob/proc/update_inv_l_hand()
	return

/mob/proc/update_inv_r_hand()
	return

/mob/proc/update_inv_wear_mask()
	return

/mob/proc/update_inv_wear_suit()
	return

/mob/proc/update_inv_w_uniform()
	return

/mob/proc/update_inv_belt()
	return

/mob/proc/update_inv_head()
	return

/mob/proc/update_inv_gloves()
	return

/mob/proc/update_mutations()
	return

/mob/proc/update_inv_wear_id()
	return

/mob/proc/update_inv_shoes()
	return

/mob/proc/update_inv_glasses()
	return

/mob/proc/update_inv_s_store()
	return

/mob/proc/update_inv_pockets()
	return

/mob/proc/update_inv_ears()
	return

/mob/proc/update_targeted()
	return
