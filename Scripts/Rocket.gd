extends RigidBody2D

signal rocket_tap

const min_speed = 450
const max_speed = 500
onready var hit_player = false
onready var on_screen = false

onready var touch_position:Vector2


func _ready():
	$AnimatedSprite.play()

func stop_particles():
	$EnginePuff.emitting = false
	$EnginePuff.hide()


# Provide some feedback to show this is indestructable
func _input_event(viewport, event, shape_idx):
	if Globals.state != Globals.ST_INGAME:
		return
	
	if event is InputEventMouseButton && event.is_pressed():
		tink(event.position)
	elif event is InputEventScreenTouch && event.is_pressed():
		tink(event.psotion)


func tink(pos:Vector2):
	# Tell parent to emit particles
	touch_position = pos
	emit_signal("rocket_tap", self)


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
