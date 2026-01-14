extends Node

@export var wolf_scene: PackedScene
@export var frog_scene: PackedScene
@export var plus_one_scene: PackedScene

const MOB_TIMER_START_TIME = 2.0


var current_score = 0
var active_mobs = []
signal game_started
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Unlock wolf ability 
	if not $Player.wolf_ability.unlocked and current_score>=5:
		$Player.wolf_ability.unlocked = true
		$HUD.show_ability_message()
	
	# Add frogs and more mob spawn
	if "frog" not in active_mobs and current_score>20:
		active_mobs.append("frog")
		$MobTimer.wait_time -= 1
	
	# Unlock frogs ability
	if not $Player.frog_ability.unlocked and current_score>=25:
		$Player.frog_ability.unlocked = true
		$HUD.show_ability_message()
	

func end_game() -> void:
	game_over.emit()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()
	
func new_game():
	game_started.emit()
	current_score = 20
	$MobTimer.wait_time = MOB_TIMER_START_TIME
	active_mobs.append("wolf")
	$Player.start($StartPosition.position)
	$Player.wolf_ability.unlocked = false
	$Player.frog_ability.unlocked = false
	
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	
	$HUD.update_score(current_score)
	$HUD.show_ready_message()	


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob_name = active_mobs.pick_random()
	
	var mob
	
	if mob_name == "wolf":
			mob = wolf_scene.instantiate()
	elif mob_name == "frog":
			mob = frog_scene.instantiate()


	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
		
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(PI / 6, -PI / 6)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
func _on_score_timer_timeout() -> void:
	current_score+=1
	$HUD.update_score(current_score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$Player.game_started = true
	

func player_hit_enemy() -> void:
	current_score+=1
	$HUD.update_score(current_score)
	var plus_one = plus_one_scene.instantiate()
	
	plus_one.position=$Player.position
	add_child(plus_one)


func _on_player_hit() -> void:
	end_game()
