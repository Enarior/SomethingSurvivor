extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func _on_sleep_timer_timeout() -> void:
	queue_free()

func die():
	self.sleeping = true
	$SleepTimer.start()
	$AnimatedSprite2D.animation = "sleep"
