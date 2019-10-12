extends CanvasLayer

signal start_game

var strings = ["Ouch!", "*chomp*", "yum", "DeeeeLish", "nom nom", "so sharp!"]

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	var rand_str = rand_range(0, strings.size() - 1)
	rand_str = 3
	show_message(strings[rand_str])
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Husky\n>Dreams<"
	$MessageLabel.show()
	$Credits.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	$Credits.hide()
	emit_signal("start_game")
