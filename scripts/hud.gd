extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $WolfAbilityCooldown/WolfAbilityCooldownTimer.time_left > 0:
		$WolfAbilityCooldown/WolfAbilityCooldownLabel.text = str(int($WolfAbilityCooldown/WolfAbilityCooldownTimer.time_left)+1)
	if $FrogAbilityCooldown/FrogAbilityCooldownTimer.time_left > 0:
		$FrogAbilityCooldown/FrogAbilityCooldownLabel.text = str(int($FrogAbilityCooldown/FrogAbilityCooldownTimer.time_left)+1)

func show_message(text,):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_ability_message(text:String):
	$AbilityUnlockedLabel.text = text
	$AbilityUnlockedLabel.show()
	$AbilityUnlockedTimer.start()

func show_game_over():
	show_message(("Game Over..."))
	await $MessageTimer.timeout
	
	show_message("Dodge the Wolves !")
	#$Message.text = "Dodge the Creeps !"
	#$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func show_ready_message():
	show_message("Get Ready !")


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_ability_unlocked_timer_timeout() -> void:
	$AbilityUnlockedLabel.hide()

func _on_player_frog_ability_used(ability_cooldown: int) -> void:
	print("frog used")
	
	$FrogAbilityCooldown/FrogAbilityCooldownTimer.wait_time = ability_cooldown
	$FrogAbilityCooldown/FrogAbilityCooldownLabel.show()
	$FrogAbilityCooldown/FrogAbilityCooldownTimer.start()

func _on_player_wolf_ability_used(ability_cooldown: int) -> void:
	print("wolf used")
	
	$WolfAbilityCooldown/WolfAbilityCooldownTimer.wait_time = ability_cooldown
	$WolfAbilityCooldown/WolfAbilityCooldownLabel.show()
	$WolfAbilityCooldown/WolfAbilityCooldownTimer.start()
	

func _on_wolf_ability_cooldown_timer_timeout() -> void:
	print("wolf timeout")
	
	$WolfAbilityCooldown/WolfAbilityCooldownLabel.hide()
	$WolfAbilityCooldown/WolfAbilityCooldownTimer.stop()


func _on_frog_ability_cooldown_timer_timeout() -> void:
	print("frog timeout")
	
	$FrogAbilityCooldown/FrogAbilityCooldownLabel.show()
	$FrogAbilityCooldown/FrogAbilityCooldownTimer.stop()
	
