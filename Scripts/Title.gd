extends Node


func _ready():
	$SkyBg.set_level()




func _on_Button_pressed():
	$AnimationPlayer.play("new_game")

func setup_done():
	get_tree().change_scene("res://Scenes/LevelCloud.tscn")
