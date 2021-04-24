extends RigidBody2D


var min_speed = 200
var max_speed = 250
var on_screen = false


func set_frame(fr:int):
	$AnimatedSprite.frame = fr


# Clear entry when it leaves the screen.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true
