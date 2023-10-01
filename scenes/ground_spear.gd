extends AnimatableBody2D
@onready var animation_player = $AnimationPlayer
@export var player_id: int
@onready var collision_detector = $Pivot/CollisionDetector
@onready var spear_collision = $Pivot/CollisionDetector/SpearCollision

var is_selected = false
var reached_floor = false
var speed = 0
const GRAVITY = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_detector.connect("body_entered",_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("l_click") and is_selected:
			process_input.rpc()
		if !reached_floor:
			speed += min(GRAVITY * delta, 5)
			var colliders = move_and_collide(Vector2(0,speed))
			if colliders:
				print(colliders.get_collider())
				var floor := colliders.get_collider() as TileMap
				if floor:
					reached_floor = true
					connect("mouse_entered",_on_mouse_entered)
					connect("mouse_exited",_on_mouse_exited)

func _on_mouse_entered() -> void:
	is_selected = true
	
func _on_mouse_exited() -> void:
	is_selected = false


func _on_body_entered(body: Node2D) -> void:
	var colliding_body := body as CharacterBody2D
	if colliding_body and colliding_body.has_method("bounce"):
		colliding_body.bounce(spear_collision.global_position)


@rpc("call_local","reliable")
func process_input() -> void:
	if not animation_player.is_playing():
			animation_player.play("activation")

func setup(player_data: Game.PlayerData):
	set_multiplayer_authority(player_data.id)
	name = str(player_data.id)
	Debug.dprint(player_data.name, 30)
	Debug.dprint(player_data.role, 30)

@rpc("any_peer","call_local")
func init(id:int, global_pos: Vector2):
	set_multiplayer_authority(id,true)
	player_id = id
	global_position = global_pos
