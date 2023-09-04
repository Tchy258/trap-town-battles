extends MultiplayerSpawner

@export var trap_spawn: Node2D
@onready var container = $"../TrapContainer"

func place(trap_id: TrapManager.traps, position: Vector2) -> void:
	#place_server.rpc(scene)
	var scene = TrapManager.get_trap_scene(trap_id)
	var trap = scene.instantiate()
	trap.player_id = get_parent().this_player_data.id
	print(trap.player_id)
	trap.global_position = trap_spawn.global_position
	container.add_child(trap, true)
	trap.init.rpc(trap.player_id,trap.global_position)


@rpc("any_peer", "call_local")
func place_server(trap_id:TrapManager.traps) -> void:
	var scene = TrapManager.get_trap_scene(trap_id)
	var trap = scene.instantiate()
	add_child(trap, true)
	trap.global_position = trap_spawn.global_position
	
