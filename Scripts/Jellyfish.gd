extends RigidBody2D

const min_speed = 280
const max_speed = 360
onready var on_screen = false


func set_anim(id:int):
	if id == 0:
		$AnimationPlayer.play("swim")
	else:
		$AnimationPlayer.play("swim2")

# Clear entry when it leaves the screen.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

