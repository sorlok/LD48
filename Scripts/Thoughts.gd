extends Area2D

signal button_clicked
signal fadeout_done

onready var cancel_click = true

func _ready():
	$Bubble1.visible = false
	$Bubble2.visible = false
	$Bubble3.visible = false
	$BubbleBig.visible = false
	$BubbleCheck.modulate = Color(1,1,1,0)
	$BubbleCheck/Cross.visible = false
	$BubbleCheck/Check.visible = false
	$BubbleCheck.visible = true


# Can click on the button now
func thoughts_are_visible():
	cancel_click = false


func fade_out():
	$AnimationPlayer.play("fade")


func finished_fade():
	emit_signal("fadeout_done")

# Animte ok/cancel depending
func play_bubble_anim(ok:bool):
	$BubbleCheck/Cross.visible = !ok
	$BubbleCheck/Check.visible = ok
	$AnimationPlayer.play("appear")


# Start animating properly
func switch_anims():
	$BubbleBig.visible = false
	$AnimationPlayer.play("Wobble")


func _input_event(viewport, event, shape_idx):
	if Globals.state != Globals.ST_ENDING || cancel_click:
		return
	
	if event is InputEventMouseButton && event.is_pressed():
		emit_signal("button_clicked")
		cancel_click = true
	elif event is InputEventScreenTouch && event.is_pressed():
		emit_signal("button_clicked")
		cancel_click = true
	


