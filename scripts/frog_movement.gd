extends Node

var frog
var moving
var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frog = get_parent()
	moving = true
	velocity = frog.linear_velocity
	frog.get_node("AnimatedSprite2D").pause()
	frog.get_node("AnimatedSprite2D").set_frame(1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_movement_timer_timeout() -> void:
	if moving:
		moving = false
		frog.linear_velocity = Vector2(0.0, 0.0)
		frog.get_node("AnimatedSprite2D").set_frame(0)
		
	else:
		moving = true
		frog.linear_velocity = velocity
		frog.get_node("AnimatedSprite2D").set_frame(1)
		
