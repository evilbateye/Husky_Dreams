signal hit

extends Area2D

#export var speed = 400  # How fast the player will move (pixels/sec).
export var speed = 3200
var screen_size  # Size of the game window.
var velocity
var last_delta

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	last_delta = delta
	velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x > 0

func _on_Player_body_entered(mob_eating_us):
	mob_eating_us.hide()
	mob_eating_us.queue_free()
	
	for mob in get_tree().get_nodes_in_group("Husky"):
		mob.linear_velocity = Vector2(0, 0)
	
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.set_animation("eaten")
	$AnimatedSprite.play()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite.set_animation("move")

func _on_AnimatedSprite_animation_finished():
	if ($AnimatedSprite.animation == "eaten"):
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * last_delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
