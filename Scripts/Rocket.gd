extends RigidBody2D

const min_speed = 450
const max_speed = 500
onready var hit_player = false
onready var on_screen = false


func _ready():
	$AnimatedSprite.play()

func stop_particles():
	$EnginePuff.emitting = false
	$EnginePuff.hide()

func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
