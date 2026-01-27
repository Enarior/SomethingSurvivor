extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func _on_sleep_timer_timeout() -> void:
	queue_free()

func die():
	if self.is_in_group("frog"):
		$Movement/MovementTimer.stop()
		
	self.linear_velocity = Vector2(0.0,0.0)
	#self.sleeping = true
	$SleepTimer.start()
	$AnimatedSprite2D.animation = "sleep"
