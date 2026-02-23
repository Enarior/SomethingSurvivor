extends Area2D

signal hit
signal sleep_enemy
signal wolf_ability_used
signal frog_ability_used
signal ability_picked_up

@export var glow_power:float = 1.0
@export var glow_speed: float = 3.0

const Ability = preload("res://scripts/ability.gd")
const Config = preload("res://scripts/config.gd")

var speed
var save_speed
var screen_size # Size of the game window.
var velocity = Vector2()
var player_scale = Vector2(0.5,0.5)

var wolf_ability
var frog_ability

# Game state
var game_started = false
var ability_active = false
var active_upgrades = 0

func _ready():
	screen_size = get_viewport_rect().size
	speed = Config.player_speed	
	hide()
	
	reset()


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
		if game_started and wolf_ability.unlocked and wolf_ability.available:
			print("wolf ability USED")
			use_ability(wolf_ability)
			wolf_ability_used.emit(wolf_ability.cooldown)
			$WolfAbilityActiveTimer.start()
			$WolfAbilityCooldownTimer.start()
	if Input.is_action_pressed("ability_frog"):
		print("frog ability")

		if game_started and frog_ability.unlocked and frog_ability.available:
			print("frog ability USED")
			use_ability(frog_ability)
			frog_ability_used.emit(frog_ability.cooldown)
			$FrogAbilityActiveTimer.start()
			$FrogAbilityCooldownTimer.start()

	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func reset():
	speed = Config.player_speed
	wolf_ability = Ability.new(	Config.wolf_ability_name,
								Config.wolf_ability_cooldown_default,
								Config.wolf_ability_duration_default,
								Config.wolf_ability_speed_default,
								Config.wolf_ability_scale_default,
								Config.wolf_ability_color)
	$WolfAbilityActiveTimer.wait_time = Config.wolf_ability_duration_default
	$WolfAbilityCooldownTimer.wait_time = Config.wolf_ability_cooldown_default
	frog_ability = Ability.new(	Config.frog_ability_name,
								Config.frog_ability_cooldown_default,
								Config.frog_ability_duration_default,
								Config.frog_ability_speed_default,
								Config.frog_ability_scale_default,
								Config.frog_ability_color)
	$FrogAbilityActiveTimer.wait_time = Config.frog_ability_duration_default
	$FrogAbilityCooldownTimer.wait_time = Config.frog_ability_cooldown_default

func use_ability(ability: Ability):

	ability.available = false
	ability.active = true
	ability_active = true
	
	save_speed = speed
	speed+=ability.speed
	glow_power = 2.0
	$AnimatedSprite2D.scale += ability.scale
	$AnimatedSprite2D.material.set_shader_parameter("glow_color",ability.glow_color)
			
func _on_body_entered(body: Node2D) -> void:
	#print(body.get_groups())
	if wolf_ability.active and body.is_in_group("wolf"):
		if body.has_method("die"):
			body.die()
			body.get_node("CollisionShape2D").set_deferred("disabled",true)
			sleep_enemy.emit("wolf")
	elif frog_ability.active and body.is_in_group("frog"):
		if body.has_method("die"):
			body.get_node("Movement").queue_free() # dirty
			body.get_node("AnimatedSprite2D").play() # dirty
			body.die()
			body.get_node("CollisionShape2D").set_deferred("disabled", true)
			sleep_enemy.emit("frog")
	elif body.is_in_group("upgrade"):
		ability_picked_up.emit()
		body.queue_free()
	else :
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled",true)


func _on_wolf_ability_active_timer_timeout() -> void:
	wolf_ability.active = false
	if frog_ability.active == false:
		ability_active = false
	
	glow_power	= 0.0
	speed = save_speed
	$AnimatedSprite2D.scale = player_scale
	


func _on_frog_ability_active_timer_timeout() -> void:
	frog_ability.active = false
	
	if wolf_ability.active == false:
		ability_active = false
	
	glow_power	= 0.0
	speed = save_speed
	$AnimatedSprite2D.scale = player_scale
	
	
	
func _on_wolf_ability_cooldown_timer_timeout() -> void:
	wolf_ability.available = true


func _on_frog_ability_cooldown_timer_timeout() -> void:
	frog_ability.available = true
