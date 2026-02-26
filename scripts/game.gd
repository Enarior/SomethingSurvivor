extends Node

@export var wolf_scene: PackedScene
@export var frog_scene: PackedScene
@export var plus_one_scene: PackedScene
@export var plus_two_scene: PackedScene
@export var upgrade_pickup_scene : PackedScene
@export var upgrade_scene : PackedScene
@export var upgrade_window_scene : PackedScene

const Upgrade = preload("res://scripts/upgrade.gd")

const MOB_TIMER_START_TIME = 2.0
const MOB_MIN_VELOCITY = 200
const MOB_MAX_VELOCITY = 300

var current_score = 0
var active_mobs = []
signal game_started
signal game_over


var upgrades = []
var player_upgrades = []
var wolf_upgrades = []
var frog_upgrades = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_upgrades()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print_info()
	# Unlock wolf ability 
	if not $Player.wolf_ability.unlocked and current_score>=3:
		$Player.wolf_ability.unlocked = true
		$HUD.show_hint("Press A to send wolves to sleep !")
		$HUD/WolfAbilityCooldown.show()
		
		upgrades.append_array(wolf_upgrades)
	
	
	# Add frogs and more mob spawn
	if "frog" not in active_mobs and current_score>20:
		active_mobs.append("frog")
		$MobTimer.wait_time -= 1
	
	# Unlock frogs ability
	if not $Player.frog_ability.unlocked and current_score>=25:
		$Player.frog_ability.unlocked = true
		$HUD.show_hint("Press E to send frogs to sleep !")
		$HUD/FrogAbilityCooldown.show()
		upgrades.append_array(frog_upgrades)
	
	# Spawn second upgrade
	if 	  (current_score>=10 and $Player.active_upgrades == 0)\
		or (current_score >= 20 and $Player.active_upgrades == 1)\
		or (current_score >= 30 and $Player.active_upgrades == 2)\
		or (current_score >= 40 and $Player.active_upgrades == 3)\
		or (current_score >= 50 and $Player.active_upgrades == 4)\
		or (current_score >= 60 and $Player.active_upgrades == 5)\
		or (current_score >= 70 and $Player.active_upgrades == 6)\
		or (current_score >= 80 and $Player.active_upgrades == 7)\
		or (current_score >= 90 and $Player.active_upgrades == 8)\
		or (current_score >= 100 and $Player.active_upgrades == 9)\
		or (current_score >= 120 and $Player.active_upgrades == 10)\
		or (current_score >= 140 and $Player.active_upgrades == 11)\
		or (current_score >= 160 and $Player.active_upgrades == 12)\
		or (current_score >= 180 and $Player.active_upgrades == 13)\
		or (current_score >= 200 and $Player.active_upgrades == 14)\
		or (current_score >= 220 and $Player.active_upgrades == 15)\
		or (current_score >= 240 and $Player.active_upgrades == 16)\
		or (current_score >= 260 and $Player.active_upgrades == 17):
		spawn_upgrade()
			

func end_game() -> void:
	game_over.emit()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over(current_score)
	$DeathSound.play()
	
func new_game():
	game_started.emit()
	current_score = 50
	$MobTimer.wait_time = MOB_TIMER_START_TIME
	active_mobs.append("wolf")
	$Player.start($StartPosition.position)
	$Player.wolf_ability.unlocked = false
	$Player.frog_ability.unlocked = false
	upgrades = player_upgrades
	$Player.active_upgrades=0
	$Player.reset()
	
	
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("upgrade", "queue_free")
	
	$HUD/StartButton.hide()
	$HUD/ScoreLabel.show()
	$HUD.update_score(current_score)
	$HUD.show_ready_message()
	await get_tree().create_timer(1.0).timeout

	$HUD.show_hint("Use arrow keys to move !")
	


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob_name = active_mobs.pick_random()
	
	var mob
	
	if mob_name == "wolf":
			mob = wolf_scene.instantiate()
	elif mob_name == "frog":
			mob = frog_scene.instantiate()


	# Choose a random Path2D
	
	var mob_paths = $MobPath.get_children()
	var mob_path = mob_paths[randi() % mob_paths.size()]
	
	# Choose a random location on Path2D.
	var mob_spawn_location = mob_path.get_node("MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
		
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(PI / 6, -PI / 6)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(MOB_MIN_VELOCITY, MOB_MAX_VELOCITY), 0.0)
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
	

func player_hit_enemy(enemy_type:String) -> void:
	if enemy_type == "wolf":
		current_score+=1
		var plus_one = plus_one_scene.instantiate()
		plus_one.position=$Player.position
		add_child(plus_one)
	if enemy_type == "frog":
		current_score+=2	
		var plus_two = plus_two_scene.instantiate()
		plus_two.position=$Player.position
		add_child(plus_two)
	$HUD.update_score(current_score)



func _on_player_hit() -> void:
	end_game()

func init_upgrades():
	player_upgrades.append(Upgrade.new("player_speed_upgrade","Increase player speed","PLAYER", "speed",$Player.speed+100))
	player_upgrades.append(Upgrade.new("player_hitbox_upgrade","Increase player size","PLAYER", "scale",1.2))
	
	wolf_upgrades.append(Upgrade.new("wolf_speed_upgrade","Increase player speed while using wolf ability","ABILITY_WOLF", "speed",100))
	wolf_upgrades.append(Upgrade.new("wolf_cooldown_upgrade","Increase wolf ability duration","ABILITY_WOLF", "duration",1))
	wolf_upgrades.append(Upgrade.new("wolf_duration_upgrade","Decrease wolf ability cooldown","ABILITY_WOLF", "cooldown", 1))
	wolf_upgrades.append(Upgrade.new("wolf_hitbox_upgrade","Increase player size while using wolf ability","ABILITY_WOLF", "scale",Vector2(0.5,0.5)))
	
	frog_upgrades.append(Upgrade.new("frog_speed_upgrade","Increase player speed while using frog ability","ABILITY_FROG", "speed",100))
	frog_upgrades.append(Upgrade.new("frog_duration_upgrade","Increase frog ability duration","ABILITY_FROG", "duration", 1))
	frog_upgrades.append(Upgrade.new("frog_cooldown_upgrade","Decrease frog ability cooldown","ABILITY_FROG", "cooldown", 1))
	frog_upgrades.append(Upgrade.new("frog_hitbox_upgrade","Increase player size while using frog ability","ABILITY_FROG", "scale", Vector2(0.5,0.5)))
	
func spawn_upgrade():
		var upgrade_pickup = upgrade_pickup_scene.instantiate()
		var upgrade_pickup_spawn_location = $UpgradeSpawn.get_node("UpgradeSpawnLocation")
		upgrade_pickup_spawn_location.progress_ratio = randf()
	
		upgrade_pickup.position = upgrade_pickup_spawn_location.position
		add_child(upgrade_pickup)
		$Player.active_upgrades+=1

func _on_player_ability_picked_up() -> void:
	# Spawn choice window
	get_tree().paused = true
	var upgrade_window = upgrade_window_scene.instantiate()
	var upgrade_panel = upgrade_window.get_node("Panel")
	
	var left_upgrade = upgrades.pick_random()
	

	var right_upgrade = upgrades.pick_random()
	while right_upgrade.upgrade_name == left_upgrade.upgrade_name:
		right_upgrade = upgrades.pick_random()
		
	upgrade_panel.get_node("LeftUpgradeButton").pressed.connect(left_upgrade.apply.bind($Player))
	#upgrade_window.get_node("LeftUpgradeButton").pressed.connect(remove_upgrade.bind(left_upgrade))
	upgrade_panel.get_node("LeftUpgradeButton").text = left_upgrade.desc
	
	upgrade_panel.get_node("RightUpgradeButton").pressed.connect(right_upgrade.apply.bind($Player))
	#upgrade_window.get_node("RightUpgradeButton").pressed.connect(remove_upgrade.bind(right_upgrade))
	upgrade_panel.get_node("RightUpgradeButton").text = right_upgrade.desc
	
	add_child(upgrade_window)
	# Update variables
	# Remove upgrade from available upgrades
	pass # Replace with function body.

func remove_upgrade(upgrade):
	var index = 0
	while index < upgrades.size():
		if upgrades[index].upgrade_name == upgrade.upgrade_name:
			upgrades.remove_at(index)
			print("removing "+upgrade.upgrade_name)
			for up in upgrades:
				print(up.upgrade_name)
		index+=1


func print_info():
	var label = $HUD.get_node("DebugLabel")
	label.text = "PLAYER SPEED : " + (str($Player.speed) + "\n")
	label.text += "PLAYER SCALE : " + (str($Player.scale) + "\n\n")

	label.text += "WOLF SPEED : " + (str($Player.wolf_ability.speed) + "\n")
	label.text += "WOLF SCALE : " + (str($Player.wolf_ability.scale) + "\n")
	label.text += "WOLF CD : " + (str($Player.wolf_ability.cooldown) + "\n")
	label.text += "WOLF CD TIMER : " + (str($Player/WolfAbilityCooldownTimer.wait_time) + "\n")
	label.text += "WOLF DURATION : " + (str($Player.wolf_ability.duration) + "\n")
	label.text += "WOLF DURATION TIMER : " + (str($Player/WolfAbilityActiveTimer.wait_time) + "\n\n")

	label.text += "FROG SPEED : " + (str($Player.frog_ability.speed) + "\n")
	label.text += "FROG SCALE : " + (str($Player.frog_ability.scale) + "\n")
	label.text += "FROG CD : " + (str($Player.frog_ability.cooldown) + "\n")
	label.text += "FROG CD TIMER : " + (str($Player/FrogAbilityCooldownTimer.wait_time) + "\n")
	label.text += "FROG DURATION : " + (str($Player.frog_ability.duration) + "\n")
	label.text += "FROG DURATION TIMER : " + (str($Player/FrogAbilityActiveTimer.wait_time) + "\n\n")
