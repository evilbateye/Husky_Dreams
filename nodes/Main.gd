extends Node2D

export (PackedScene) var Mob
var score
var reset_husky_sonata

func _ready():
	randomize()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$AppleChomp.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Survive")
	$HUD/ArrowKeys.hide()
	reset_husky_sonata = true
	$HuskySonata.stop()
	$AppleChomp.stop()

func _on_MobTimer_timeout():
	if reset_husky_sonata:
		$HuskySonata.play()
		reset_husky_sonata = false
	
	var rand_float = rand_range(0, 1)
	$MobPath/MobSpawnLocation.set_unit_offset(rand_float)
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	var mob_position = $MobPath/MobSpawnLocation.position
	mob.position = mob_position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_Chillymanjaro_finished():
	$Chillymanjaro.play()
