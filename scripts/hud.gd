extends CanvasLayer

signal start_game

var wolf_bar_percentage = 100
var frog_bar_percentage = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $WolfAbilityCooldown/WolfAbilityCooldownTimer.time_left > 0:
		$WolfAbilityCooldown/WolfAbilityCooldownLabel.text = str(int($WolfAbilityCooldown/WolfAbilityCooldownTimer.time_left)+1)
	if $FrogAbilityCooldown/FrogAbilityCooldownTimer.time_left > 0:
		$FrogAbilityCooldown/FrogAbilityCooldownLabel.text = str(int($FrogAbilityCooldown/FrogAbilityCooldownTimer.time_left)+1)
	
	wolf_bar_percentage = 100 - ($WolfAbilityCooldown/WolfAbilityCooldownTimer.time_left*100) / $WolfAbilityCooldown/WolfAbilityCooldownTimer.wait_time
	$WolfAbilityCooldown/WolfAbilityCooldownProgressBar.value = wolf_bar_percentage
	if wolf_bar_percentage<100:
		$WolfAbilityCooldown/WolfAbilitySprite.modulate.a = 0.2
	else:
		$WolfAbilityCooldown/WolfAbilitySprite.modulate.a = 1
		
	frog_bar_percentage = 100 - ($FrogAbilityCooldown/FrogAbilityCooldownTimer.time_left*100) / $FrogAbilityCooldown/FrogAbilityCooldownTimer.wait_time
	$FrogAbilityCooldown/FrogAbilityCooldownProgressBar.value = frog_bar_percentage
	if frog_bar_percentage<100:
		$FrogAbilityCooldown/FrogAbilitySprite.modulate.a = 0.2
	else:
		$FrogAbilityCooldown/FrogAbilitySprite.modulate.a = 1
		
func show_message(text,duration):
	$MessageTimer.wait_time = duration
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_hint(text:String):
	$Hint/HintLabel.text = text
	$Hint.show()
	$Hint/HintTimer.start()

func show_score(score: int):
	$Stars.show()

	if score>0:
		$Stars/Star1.show()

	if score>25:
		$Stars/Star2.show()

	if score>50:
		$Stars/Star3.show()


func show_game_over(score: int):
	$ScoreLabel.hide()
	$WolfAbilityCooldown.hide()
	$FrogAbilityCooldown.hide()
	
	show_message("Game Over...", 2.0)
	await $MessageTimer.timeout
	
	show_message("Your score :   ", 1) # Dirty
	await $MessageTimer.timeout
	
	show_message("Your score : " + str(score), 1) # Dirty
	await $MessageTimer.timeout
	
	show_score(score)

	#show_message("Dodge the Wolves !")
	#$Message.text = "Dodge the Creeps !"
	#$Message.show()
	
	await get_tree().create_timer(2.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func show_ready_message():
	show_message("Get Ready !", 2.5)
	await $MessageTimer.timeout
	$Message.hide()
	


func _on_start_button_pressed():
	$StartButton.hide()
	$Stars/Star1.hide()
	$Stars/Star2.hide()
	$Stars/Star3.hide()
	
	$ScoreLabel.show()
	start_game.emit()
	

#
#func _on_message_timer_timeout() -> void:
	#$Message.hide()


func _on_ability_unlocked_timer_timeout() -> void:
	$Hint.hide()

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
	
	$FrogAbilityCooldown/FrogAbilityCooldownLabel.hide()
	$FrogAbilityCooldown/FrogAbilityCooldownTimer.stop()
