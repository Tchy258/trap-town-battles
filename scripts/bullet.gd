extends Area2D

@export var speed = 300


func _ready() -> void:
	if multiplayer.is_server():
		body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	Debug.dprint(body.name)
	queue_free()
