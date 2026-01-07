extends Area2D

signal hit
signal ability_used
signal sleep_enemy

@export var glow_power = 1.0
@export var glow_speed = 3.0
var velocity = Vector2()

# CONST
@export var speed = 300 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Game state
var game_started = false
var ability_unlocked = false
var ability_active = false
var ability_available = true


func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	velocity = Vector2.ZERO
	
	get_input()

	glow_power+= delta * glow_speed
	if ability_active:
		if (glow_power >= 2.0 and glow_speed > 0) or (glow_power <=1.0 and glow_speed <0):
			glow_speed *= -1.0
	else:
		glow_power	= 0.0
	$AnimatedSprite2D.get_material().set_shader_parameter("glow_power", glow_power)
	
	if velocity.length() > 0 :
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func get_input():
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("ability"):
		print(game_started, ability_unlocked, ability_available)
		if game_started and ability_unlocked and ability_available:
			ability_used.emit($AbilityCooldownTimer.wait_time)
			$AbilityActiveTimer.start()
			$AbilityCooldownTimer.start()
			ability_available = false
			ability_active = true
			glow_power = 2.0
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

func _on_body_entered(body: Node2D) -> void:
	if ability_active:
		if body.has_method("die"):
			body.die()
			sleep_enemy.emit()
	else :
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled",true)


func _on_ability_active_timer_timeout() -> void:
	ability_active = false
	glow_power	= 0.0


func _on_ability_cooldown_timer_timeout() -> void:
	ability_available = true
