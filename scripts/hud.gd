extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AbilityCooldownLabel.text = str(int($AbilityCooldownTimer.time_left)+1)

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


func _on_player_ability_used(ability_cooldown: int) -> void:
	$AbilityCooldownTimer.wait_time = ability_cooldown
	$AbilityCooldownLabel.show()
	$AbilityCooldownTimer.start()
	

func _on_ability_cooldown_timer_timeout() -> void:
		$AbilityCooldownLabel.hide()
