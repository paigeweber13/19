extends TileMap

func _on_finish_line_body_entered(body):
	get_tree().change_scene("res://levels/02.tscn")
