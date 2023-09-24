extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal shoot_button(position: Vector2)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Message.text = "Watzup"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$TouchScreenButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$TouchScreenButton.hide()	
	$StartButton.hide()
	start_game.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			shoot_button.emit(event.position)


func _on_touch_screen_button_pressed():
	$TouchScreenButton.hide()
	$StartButton.hide()	
	start_game.emit()
