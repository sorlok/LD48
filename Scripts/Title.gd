extends Node

export (AudioStream) var ButtonPress
export (AudioStream) var Falling

func _ready():
	$SkyBg.set_level()
	Bgm.play_music(0)


func just_fall():
	$AudioStreamPlayer.stream = Falling
	$AudioStreamPlayer.play()

func _on_Button_pressed():
	$AudioStreamPlayer.stream = ButtonPress
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("new_game")

func setup_done():
	get_tree().change_scene("res://Scenes/LevelCloud.tscn")


func _on_Instructions_pressed():
	$AudioStreamPlayer.stream = ButtonPress
	$AudioStreamPlayer.play()
	if $Title/Title.visible:
		$Title/Title.visible = false
		$Title/Instructions.visible = true
	else:
		$Title/Title.visible = true
		$Title/Instructions.visible = false
