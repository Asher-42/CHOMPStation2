/obj/item/capture_crystal/cheap/soulgem_necklace
	name = "Soulgem Necklace"
	desc = "A silent, unassuming crystal in what appears to be some kind of steel housing. This one seems to be cheaply made and can only handle a willing mind."
	icon = 'modular_chomp/icons/inventory/accessory/item.dmi'
	icon_override = 'modular_chomp/icons/inventory/accessory/mob.dmi'
	empty_icon = "soulnecklace_empty"
	full_icon = "soulnecklace_occupied"
	icon_state = "soulnecklace" //not worn one
	item_state = "soulnecklace_m"
	slot_flags = SLOT_MASK
	var/slot = ACCESSORY_SLOT_DECOR

/datum/gear/accessory/soulgem_necklace
	display_name = "soulgem necklace"
	description = "A shiny steel chain with a vague gemstone."
	path = /obj/item/capture_crystal/cheap/soulgem_necklace
