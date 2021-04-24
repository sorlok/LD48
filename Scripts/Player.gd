extends Area2D

# On collide
signal hit

# Speed to move left/right
var speed:int = 400

# Size of the screen and margin (for clamping)
var screen_size:Vector2
var screen_margin_x:Vector2
var screen_margin_y:Vector2


func _ready():
	$AnimatedSprite.playing = true
	screen_size = get_viewport_rect().size
	screen_margin_x = Vector2(50, 30)
	screen_margin_y = Vector2(20, 20)



func _process(delta):
	# Move left/right with A+D
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	
	# Move left/right with motion controls
	# We cheat and only use acceleration. But this is probably fine for now.
	var accX = Input.get_accelerometer().x
	var grav = 3 # Maximum gravity
	if abs(accX) > 0.1: # Scale to gravity, with a deadzone.
		accX = clamp(accX, -grav, grav)
		velocity.x += 2*speed*(accX / grav)
	
	# Force move
	position += velocity * delta
	position.x = clamp(position.x, screen_margin_x[0], screen_size.x-screen_margin_x[1])
	position.y = clamp(position.y, screen_margin_y[0], screen_size.y-screen_margin_y[1])


func _on_Player_body_entered(body):
	# For now, just die.
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
