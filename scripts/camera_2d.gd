extends Camera2D

var velocidade = 500

func calc_direcao() -> Vector2:
	var direcao = Vector2(0,0)
	
	if Input.is_key_pressed(KEY_UP):
		direcao += Vector2(0,-1)
	if Input.is_key_pressed(KEY_RIGHT):
		direcao += Vector2(1,0)
	if Input.is_key_pressed(KEY_DOWN):
		direcao += Vector2(0,1)
	if Input.is_key_pressed(KEY_LEFT):
		direcao += Vector2(-1,0)
	
	direcao = direcao.normalized()
	return direcao

func _process(delta: float) -> void:
	
	self.position += calc_direcao() * delta * velocidade
