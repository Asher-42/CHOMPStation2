/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/item/powercell/AssembleDesignName()
	name = "Power Cell Model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	C.update_icon()
	return C

/*
//Big Cells
*/
/datum/design/item/powercell/basic
	name = "basic"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell
	category = list("Misc")
	sort_string = "BAAAA"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/high
	name = "high-capacity"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
	build_path = /obj/item/cell/high
	category = list("Misc")
	sort_string = "BAAAB"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/cell/super
	category = list("Misc")
	sort_string = "BAAAC"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = list("Misc")
	sort_string = "BAAAD"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/giga
	name = "giga-capacity"
	id = "giga_cell"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 5, TECH_ARCANE = 1, TECH_PHORON = 4)
	materials = list(MAT_STEEL = 1000, MAT_GOLD = 300, MAT_SILVER = 300, MAT_GLASS = 100, MAT_PHORON = 1000, MAT_DURASTEEL = 100, MAT_URANIUM = 100)
	build_path = /obj/item/cell/giga
	category = list("Misc")
	sort_string = "BAAAE"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/potato
	name = "potato cell"
	id = "potato_cell"
	materials = list(MAT_STEEL = 100, MAT_GLASS = 10)
	build_path = /obj/item/cell/potato
	category = list("Misc")
	sort_string = "BAAAF"
	department = LATHE_ALL | LATHE_ENGINEERING

/*
//Device Cells
*/
/datum/design/item/powercell/device
	name = "device"
	build_type = PROTOLATHE
	id = "device"
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
	build_path = /obj/item/cell/device
	category = list("Misc")
	sort_string = "BAABA"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/device_empproof
	name = "device, empproof"
	id = "empproof_device"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2, TECH_PHORON = 1)
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25, MAT_MORPHIUM = 25, MAT_PHORON = 25)
	build_path = /obj/item/cell/device/empproof
	category = list("Misc")
	sort_string = "BAABB"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/advance_device
	name = "device, advanced"
	id = "advance_device"
	req_tech = list(TECH_POWER = 2, TECH_MATERIAL = 1)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell/device/weapon
	category = list("Misc")
	sort_string = "BAABC"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/advance_device_empproof
	name = "device, advanced empproof"
	id = "empproof_advanced_device"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4, TECH_PHORON = 4)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50, MAT_MORPHIUM = 50, MAT_PHORON = 50)
	build_path = /obj/item/cell/device/weapon/empproof
	category = list("Misc")
	sort_string = "BAABD"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/advance_device_recharge
	name = "device, advanced recharging"
	id = "recharging_advanced_device"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_PHORON = 6)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 400, MAT_DURASTEEL = 100, MAT_METALHYDROGEN = 200, MAT_VERDANTIUM = 150, MAT_PHORON = 2000)
	build_path = /obj/item/cell/device/weapon/recharge
	category = list("Misc")
	sort_string = "BAABE"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/super_device
	name = "device, super"
	id = "super_device"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70, MAT_GOLD = 50, MAT_SILVER = 20)
	build_path = /obj/item/cell/device/super
	category = list("Misc")
	sort_string = "BAABF"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/hype_device
	name = "device, hyper"
	id = "hyper_device"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 1400, MAT_GLASS = 1400, MAT_GOLD = 150, MAT_SILVER = 150)
	build_path = /obj/item/cell/device/hyper
	category = list("Misc")
	sort_string = "BAABG"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/giga_device
	name = "device, giga"
	id = "giga_device"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_ARCANE = 1, TECH_PHORON = 4)
	materials = list(MAT_STEEL = 2000, MAT_GOLD = 500, MAT_SILVER = 500, MAT_GLASS = 100, MAT_PHORON = 2000, MAT_DURASTEEL = 200, MAT_URANIUM = 200)
	build_path = /obj/item/cell/device/giga
	category = list("Misc")
	sort_string = "BAAAH"
	department = LATHE_ALL | LATHE_ENGINEERING

/datum/design/item/powercell/omni_device
	name = "device, omni"
	req_tech = list(TECH_POWER = 8, TECH_MATERIAL = 7, TECH_ARCANE = 2, TECH_PHORON = 4, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	id = "omni-device"
	materials = list(MAT_STEEL = 1700, MAT_GLASS = 550, MAT_DURASTEEL = 230, MAT_MORPHIUM = 320, MAT_METALHYDROGEN = 600, MAT_URANIUM = 60, MAT_VERDANTIUM = 150, MAT_PHORON = 900)
	build_path = /obj/item/cell/device/weapon/recharge/alien/omni
	category = list("Misc")
	sort_string = "BAABI"
	department = LATHE_ALL | LATHE_ENGINEERING

/*
//Mecha Cells
*/
/datum/design/item/powercell/mecha/high
	name = "high-capacity mecha"
	id = "high_mech_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 600, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/mech/high
	category = list("Misc")
	sort_string = "BAACA"

/datum/design/item/powercell/mecha/super
	name = "super-capacity mecha"
	id = "super_mech_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 200, MAT_SILVER = 200, MAT_GLASS = 80)
	build_path = /obj/item/cell/mech/super
	category = list("Misc")
	sort_string = "BAACB"
