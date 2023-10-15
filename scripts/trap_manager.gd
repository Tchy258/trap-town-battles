extends Node

enum traps {
	ARROW_CEILING_TRAP,
	GROUND_SPEAR_TRAP,
	MINE_TRAP
}

const trap_dict = {
	traps.ARROW_CEILING_TRAP: preload("res://scenes/ceiling_trap.tscn"),
	traps.GROUND_SPEAR_TRAP: preload("res://scenes/ground_spear.tscn"),
	traps.MINE_TRAP: preload("res://scenes/mine.tscn")
}
func get_trap_scene(trap_id: traps):
	return trap_dict[trap_id]
