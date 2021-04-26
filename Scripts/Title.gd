extends Node


func _ready():
	$SkyBg.set_level()




func _on_Button_pressed():
	$AnimationPlayer.play("new_game")

func setup_done():
	get_tree().change_scene("res://Scenes/LevelCloud.tscn")


func _on_Instructions_pressed():
	if $Title/Title.visible:
		$Title/Title.visible = false
		$Title/Instructions.visible = true
	else:
		$Title/Title.visible = true
		$Title/Instructions.visible = false
