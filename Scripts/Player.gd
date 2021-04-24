extends Area2D

# On collide
signal collide_cloud
signal collide_car
signal first_force_move_done

# Speed to move left/right
var speed:int = 400

# How fast are we falling. Used for waking up calculation
var fall_speed:int = 100

# Are we "force moving" anywhere?
var force_move = null

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
	var velocity = Vector2()
	var min_margin = screen_margin_x[0]
	var max_margin = screen_size.x-screen_margin_x[1]
	
	if Globals.state == Globals.ST_INGAME:
		# Move left/right with A+D
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
	elif Globals.state == Globals.ST_ENDING:
		if force_move != null:
			if position.x < force_move.x:
				velocity.x += speed
				max_margin = force_move.x
			elif position.x > force_move.x:
				velocity.x -= speed
				min_margin = force_move.x


	# Update position
	position += velocity * delta
	position.x = clamp(position.x, min_margin, max_margin)
	position.y = clamp(position.y, screen_margin_y[0], screen_size.y-screen_margin_y[1])
	
	# Done with move?
	# TODO: This is not the right way to do things.
	if force_move != null && position.x == force_move.x:
		emit_signal("first_force_move_done")
		force_move = null


func increase_fall_speed(amt:int):
	# At least keep them safe from moving objects...
	if Globals.state != Globals.ST_INGAME && amt < 0:
		return
	
	fall_speed = clamp(fall_speed+amt, 0, 100)


func move_to(dest:Vector2):
	force_move = dest



func _on_Player_body_entered(body:Node):
	# Clouds slow us down
	if body.is_in_group("cloud"):
		increase_fall_speed(-1)
		emit_signal("collide_cloud", body)
		body.queue_free()
		return
	
	if body.is_in_group("car"):
		increase_fall_speed(10)
		emit_signal("collide_car", body)
		body.queue_free()
		$AnimationPlayer.play("damage")
		return
	
	if body.is_in_group("rocket") && !body.hit_player: # This doesn't destroy the rocket
		body.hit_player = true
		increase_fall_speed(20)
		emit_signal("collide_car", body) # Close enough
		$AnimationPlayer.play("damage")
		return


