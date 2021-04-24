extends RigidBody2D

var min_speed = 350
var max_speed = 400

func _ready():
	$SmokeTimer.start()


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
		
