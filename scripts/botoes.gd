extends CanvasLayer


func _ready() -> void:
	get_node("comeco").connect("pressed",comeco)
	get_node("final").connect("pressed",final)
	

func comeco() -> void:
	get_node("/root/Main/Camera2D").position = Vector2(128*3,128)

func final() ->void:
	var cont = get_node("/root/Main").cont
	print(cont)
	get_node("/root/Main/Camera2D").position = Vector2(128*3,cont*128*4)
	
