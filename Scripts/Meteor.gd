extends RigidBody2D

signal car_explode

onready var min_speed = 350
onready var max_speed = 500
onready var dying = false
onready var on_screen = false

# Where we were pressed
onready var touch_position:Vector2


func set_stretch(val:float):
	$Sprite.scale = Vector2(val, val)
	$CollisionShape2D.scale = Vector2(val, val)


func _input_event(viewport, event, shape_idx):
	if Globals.state != Globals.ST_INGAME:
		return
	
	if event is InputEventMouseButton && event.is_pressed():
		defeat(event.position)
	elif event is InputEventScreenTouch && event.is_pressed():
		defeat(event.psotion)
		

func stop_particles():
	pass

func defeat(press_pos):
	if dying:
		return
	dying = true
	
	# Tell parent to emit particles
	touch_position = press_pos
	emit_signal("car_explode", self)
	
	# Remove the car
	hide()
	queue_free()


func set_frame(fr:int):
	$AnimatedSprite.frame = fr


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true
