extends Node

@export var mob_scene: PackedScene
@export var plus_one_scene: PackedScene

var current_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ($Player.ability_enabled == false) and current_score>=5:
		$Player.ability_enabled = true
		$HUD.show_ability_message()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()
	
func new_game():
	current_score = 5
	$Player.start($StartPosition.position)
	$Player.ability_enabled = false
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	
	$HUD.update_score(current_score)
	$HUD.show_ready_message()	


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
		
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(PI / 4, -PI / 4)
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
