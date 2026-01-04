extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PoofTimer.start()


func _on_poof_timer_timeout() -> void:
	queue_free()
