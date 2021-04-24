extends RigidBody2D

signal car_explode

var min_speed = 350
var max_speed = 400
var dying = false
var on_screen = false

# Where we were pressed
var touch_position:Vector2

func _ready():
	$SmokeTimer.start()


func _input_event(viewport, event, shape_idx):
	if Globals.state != Globals.ST_INGAME:
		return
	
	if event is InputEventMouseButton && event.is_pressed():
		defeat(event.position)
	elif event is InputEventScreenTouch && event.is_pressed():
		defeat(event.psotion)
		

func stop_particles():
	$GasPuff.emitting = false
	$GasPuff.hide()

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


func _on_SmokeTimer_timeout():
	$GasPuff.emitting = !$GasPuff.emitting
	if $GasPuff.emitting:
		$SmokeTimer.wait_time = 0.25
	else:
		$SmokeTimer.wait_time = 0.5
		



func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true
