extends Node2D
var velocity  = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PoofTimer.start()
	velocity = Vector2(randf_range(-50.0,50.0),-150.0)

func _process(delta) -> void:
	position += velocity * delta


func _on_poof_timer_timeout() -> void:
	queue_free()
