extends Area2D

signal hit
signal sleep_enemy
signal wolf_ability_used
signal frog_ability_used

@export var glow_power:float = 1.0
@export var glow_speed: float = 3.0

const Ability = preload("res://scripts/ability.gd")

@export var speed: float = 300 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var velocity = Vector2()

var wolf_ability
var frog_ability

# Game state
var game_started = false
var ability_active = false


func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
	wolf_ability = Ability.new("wolf", 3.0, Color("#c79c6d92"))
	frog_ability = Ability.new("frog", 5.0, Color("4a946792"))

func _process(delta):
	velocity = Vector2.ZERO
	
	get_input()
	
	if glow_speed:
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
	if Input.is_action_pressed("ability_wolf"):
		#print("ability wolf")
		#print(game_started, wolf_ability.unlocked, wolf_ability.available)
		if game_started and wolf_ability.unlocked and wolf_ability.available and not ability_active:
			wolf_ability_used.emit(wolf_ability.ability_cooldown)
			$WolfAbilityActiveTimer.start()
			$WolfAbilityCooldownTimer.start()
			wolf_ability.available = false
			wolf_ability.active = true
			ability_active = true
			glow_power = 2.0
			$AnimatedSprite2D.material.set_shader_parameter("glow_color",wolf_ability.ability_glow_color)
	if Input.is_action_pressed("ability_frog"):
		#print("frog ability")
		#print("game_started: " + str(game_started))
		#print("frog_ability.unlocked: " + str(frog_ability.unlocked))
		#print("frog_ability.available: " + str(frog_ability.available))
		#print("ability_active" + str(ability_active))
		
		if game_started and frog_ability.unlocked and frog_ability.available and not ability_active:
			frog_ability_used.emit(frog_ability.ability_cooldown)
			$FrogAbilityActiveTimer.start()
			$FrogAbilityCooldownTimer.start()
			frog_ability.available = false
			frog_ability.active = true
			ability_active = true
			glow_power = 2.0
			$AnimatedSprite2D.material.set_shader_parameter("glow_color",frog_ability.ability_glow_color)
			
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

func _on_body_entered(body: Node2D) -> void:
	if wolf_ability.active and body.is_in_group("wolf") :
		if body.has_method("die"):
			body.die()
			sleep_enemy.emit()
	elif frog_ability.active and body.is_in_group("frog"):
		if body.has_method("die"):
			body.die()
			sleep_enemy.emit()
	else :
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled",true)


func _on_wolf_ability_active_timer_timeout() -> void:
	wolf_ability.active = false
	ability_active = false
	
	glow_power	= 0.0


func _on_frog_ability_active_timer_timeout() -> void:
	frog_ability.active = false
	ability_active = false
	
	glow_power	= 0.0
	
	
func _on_wolf_ability_cooldown_timer_timeout() -> void:
	wolf_ability.available = true


func _on_frog_ability_cooldown_timer_timeout() -> void:
	frog_ability.available = true
