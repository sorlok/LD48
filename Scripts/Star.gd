extends RigidBody2D

const min_speed = 100
const max_speed = 150

onready var on_screen = false

func _ready():
	$Timer.wait_time = rand_range(1, 2)
	$Timer.start()
	var sz = rand_range(0.2, 1)
	$Sprite.scale = Vector2(sz, sz)

func _on_Timer_timeout():
	visible = !visible
	$Timer.stop()
	if visible:
		$Timer.wait_time = rand_range(1, 3)
	else:
		$Timer.wait_time = 0.2
	$Timer.start()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
