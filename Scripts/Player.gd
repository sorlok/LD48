extends Area2D

export (AudioStream) var CloudSound
export (AudioStream) var CarAlarmSound
export (AudioStream) var RocketSound
export (AudioStream) var SheepSound
export (AudioStream) var BubbleSound
export (AudioStream) var JellyfishSound
export (AudioStream) var VictorySound
export (AudioStream) var CanCrushSound
export (AudioStream) var AngelSound
export (AudioStream) var PlanetSound

# On collide
signal collide_cloud
signal collide_sheep
signal collide_car
signal first_force_move_done   # We are at the center of the screen
signal second_force_move_done  # We have touched down on the bed

# Which audio stream player to use for the next sound
onready var audio = 0

# Speed to move left/right
const speed:int = 400

# How fast are we falling. Used for waking up calculation
onready var fall_speed:int = 50

# How many sheep have we collected. Sheep multiply the value of clouds
onready var sheep_count:int = 0

# Are we "force moving" anywhere?
onready var force_move = null

# Is this move a "falling to the bed" move? If so, set this to the distance from our starting pos to the target.
onready var falling_to_bed_dist = null

# When to show "hitting" the bed (y co-ord)
onready var bed_hit_y = null
onready var showed_bed_hit = false

# Size of the screen and margin (for clamping)
onready var screen_size:Vector2
onready var screen_margin_x:Vector2
onready var screen_margin_y:Vector2

# Did we win? (Only matters when the level is over)
onready var victory:bool


func _ready():
	$AnimatedSprite.playing = true
	screen_size = get_viewport_rect().size
	screen_margin_x = Vector2(50, 30)
	screen_margin_y = Vector2(20, 20)



func _process(delta):
	var velocity = Vector2()
	var min_margin = screen_margin_x[0]
	var max_margin = screen_size.x-screen_margin_x[1]
	var min_margin_y = screen_margin_y[0]
	var max_margin_y = screen_size.y-screen_margin_y[1]
	
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
		if force_move != null:  # TODO: Just use vector math.
			# Adjust speed based on how far we are from the destination.
			var speed_real = speed
			if falling_to_bed_dist != null && victory: # Only slow down if we're winning
				var dist_perc = position.distance_to(force_move) / falling_to_bed_dist
				if dist_perc < 0.5:
					speed_real = clamp(speed * dist_perc + 0.5, speed*0.2, speed)
					$AnimatedSprite.speed_scale = clamp(dist_perc * 2, 0, 1)
				else:
					speed_real *= 0.75
			
			if position.x < force_move.x:
				velocity.x += speed_real
				max_margin = force_move.x
			elif position.x > force_move.x:
				velocity.x -= speed_real
				min_margin = force_move.x
			if position.y < force_move.y:
				velocity.y += speed_real
				max_margin_y = force_move.y
			elif position.y > force_move.y:
				velocity.y -= speed_real
				min_margin_y = force_move.y

	# Update position
	position += velocity * delta
	position.x = clamp(position.x, min_margin, max_margin)
	position.y = clamp(position.y, min_margin_y, max_margin_y)
	
	# Show "bed hit"
	if bed_hit_y!=null && position.y >= bed_hit_y && !showed_bed_hit:
		showed_bed_hit = true
		emit_signal("collide_car", self) # Close enough
		play_sound(RocketSound)
		$AnimationPlayer.play("damage")
	
	# Done with move?
	# TODO: This is not the right way to do things.
	if force_move != null && position.x == force_move.x && position.y == force_move.y:
		force_move = null
		if falling_to_bed_dist == null:
			emit_signal("first_force_move_done")
		else:
			# Sleep position if we won
			if victory:
				play_sound(VictorySound)
				$AnimatedSprite.play("sleep")
				position.x += 5
				position.y += 51
			else:
				$AnimatedSprite.speed_scale = 0
			
			# Tell the controller
			emit_signal("second_force_move_done")
			falling_to_bed_dist = null

func play_sound(sound:AudioStream):
	if audio == 0:
		audio = 1
		$AudioStreamPlayer.stream = sound
		$AudioStreamPlayer.play()
	else:
		audio = 0
		$AudioStreamPlayer2.stream = sound
		$AudioStreamPlayer2.play()


func stand_up():
	$AnimatedSprite.play("stand")
	position.y -= 46

func increase_fall_speed(amt:int):
	# At least keep them safe from moving objects...
	if Globals.state != Globals.ST_INGAME && amt < 0:
		return
	
	fall_speed = clamp(fall_speed+amt, 0, 100)

func increase_sheep_count(amt:int):
	sheep_count = clamp(sheep_count+amt, 0, 5)


func move_to(dest:Vector2):
	force_move = dest


func move_to_bed():
	# Move to a position direclty on top of the bed
	var extra = 0 if victory else 82
	move_to(Vector2(position.x, screen_size.y - 195 + extra))
	falling_to_bed_dist = position.distance_to(force_move)
	if !victory:
		bed_hit_y = screen_size.y - 195


# Instant
func jump_into_bed():
	position.x += 5
	position.y = screen_size.y - 195 + 51
	$AnimatedSprite.play("sleep")


func _on_Player_body_entered(body:Node):
	# Clouds slow us down
	if body.is_in_group("cloud"):
		if Globals.rel_level() == 0:
			play_sound(CloudSound)
		elif Globals.rel_level() == 1:
			play_sound(BubbleSound)
		else:
			play_sound(AngelSound)
		
		increase_fall_speed(Globals.DMG_CLOUD * (sheep_count+1))
		emit_signal("collide_cloud", body)
		body.queue_free()
		return
	
	# Sheep boost our points
	if body.is_in_group("sheep"):
		if Globals.rel_level() == 0:
			play_sound(SheepSound)
		elif Globals.rel_level() == 1:
			play_sound(JellyfishSound)
		else:
			play_sound(PlanetSound)
		
		increase_sheep_count(1)
		emit_signal("collide_sheep", body)
		body.queue_free()
		$AnimationPlayer.play("powerup")
		return
	
	# Obstacles
	if body.is_in_group("car"):
		if Globals.rel_level() == 0:
			play_sound(CarAlarmSound)
		elif Globals.rel_level() == 1:
			play_sound(CanCrushSound)
		else:
			play_sound(RocketSound)
		
		increase_fall_speed(Globals.DMG_CAR)
		emit_signal("collide_car", body)
		body.queue_free()
		$AnimationPlayer.play("damage")
		return
	
	# Obstacles
	if body.is_in_group("rocket") && !body.hit_player: # This doesn't destroy the rocket
		play_sound(RocketSound)
		
		body.hit_player = true
		increase_fall_speed(Globals.DMG_ROCKET)
		emit_signal("collide_car", body) # Close enough
		$AnimationPlayer.play("damage")
		return


