extends TileMap

func _on_goback_body_entered(body):
	get_tree().change_scene("res://levels/01.tscn")

func _on_finishline_body_entered(body):
	get_tree().change_scene("res://cutscenes/ending.tscn")
