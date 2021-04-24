extends RigidBody2D

var min_speed = 450
var max_speed = 500
var hit_player = false
var on_screen = false


func _ready():
	$AnimatedSprite.play()

func stop_particles():
	$EnginePuff.emitting = false
	$EnginePuff.hide()

func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
