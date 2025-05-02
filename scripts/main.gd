extends Node2D

var posicoes = [
	Vector2(1,1),
	Vector2(2,1),
	Vector2(3,1),
	
	Vector2(1,2),
	Vector2(2,2),
	Vector2(3,2),
	
	Vector2(1,3),
	Vector2(2,3),
	Vector2(3,3)
	]
var cont = 0

func _ready() -> void:
	var pecas_instancia = preload("res://cenas/pecas.tscn").instantiate()
	pecas_instancia.name = str("Pecas",cont)
	self.add_child(pecas_instancia)
	pecas_instancia.ready
	#pecas_instancia.gerar([0,1,2,3,4,5,6,7])
	#0 é a primeira posicao pra primeira peca
	pecas_instancia.gerar_aleatorio()


func resolveu(pecas: Array):
	var flag = true
	for i in 8:
		if pecas[i].position == posicoes[i] *128:
			flag = false
	return flag

func instanciar(pecas: Array):
	cont += 1
	var pecas_atuais = preload("res://cenas/pecas.tscn").instantiate()
	pecas_atuais.name = str("Pecas",cont)
	pecas_atuais.gerar(pecas)
	pecas_atuais.position += Vector2(0, 512)
	self.add_child(pecas_atuais)

func posicoes_validas(vazio: Vector2) -> Array:
	var possiveis: Array = [
		vazio+Vector2(1,0),
		vazio+Vector2(0,1),
		vazio+Vector2(-1,0),
		vazio+Vector2(0,-1)]
	
	var validas: Array = []
	for i in possiveis.size():
		if posicoes.has(possiveis[i]):
			validas.append(possiveis[i])
	
	return validas


func pontuar(peca: Sprite2D, vazio: Vector2) -> int:
	var pontos: int
	var origem = peca.name.get_slice("a",1)
	var vetor_origem: Vector2i
	match origem:
		1:
			vetor_origem = Vector2i(1,1)
		2:
			vetor_origem = Vector2i(2,1)
		3:
			vetor_origem = Vector2i(3,1)
		4:
			vetor_origem = Vector2i(1,2)
		5:
			vetor_origem = Vector2i(2,2)
		6:
			vetor_origem = Vector2i(3,2)
		7:
			vetor_origem = Vector2i(1,3)
		8:
			vetor_origem = Vector2i(2,3)
		
	var posicao_peca:Vector2i = Vector2i(peca.position/128)
	pontos += abs(vetor_origem.x - posicao_peca.x)
	pontos += abs(vetor_origem.y - posicao_peca.y)
	return pontos

func pensar(pecas: Array) -> Array:
	var pontuador: Sprite2D
	var pontuacao = 0
	var posicao_livre = get_node(str("Pecas",cont)).posicoes_livres[0]
	var vetor_livre = get_node(str("Pecas",cont)).posicoes[posicao_livre]
	var pecas_validas = posicoes_validas(vetor_livre)
	
	for i in pecas_validas.size():
		var numero_peca = converter(pecas_validas[i])
		var peca = get_node(str("Pecas",cont)).get_node(str("peca",numero_peca))
		var pontos = pontuar(peca, vetor_livre)
		if pontuacao < pontos:
			pontuacao = pontos
			pontuador = peca
	
	return Array([pontuador, vetor_livre])

func converter(vetor: Vector2i) -> int:
	var posicao
	match vetor:
		Vector2i(1, 1):
			posicao = 1
		Vector2i(2, 1):
			posicao = 2
		Vector2i(3, 1):
			posicao = 3
		Vector2i(1, 2):
			posicao = 4
		Vector2i(2, 2):
			posicao = 5
		Vector2i(3, 2):
			posicao = 6
		Vector2i(1, 3):
			posicao = 7
		Vector2i(2, 3):
			posicao = 8
	
	return posicao


func mover(peca: Sprite2D, posicao: Vector2i):
	var posicoes_novas: Array = []
	var pecas_atuais = get_node(str("Pecas",cont)).get_children()
	pecas_atuais.erase(peca)
	var peca_numero = peca.name.get_slice("a",1)
	
	for i in 8:
		if i != int(peca_numero)-1:
			var peca_index
			for j in pecas_atuais.size():
				if pecas_atuais[j].name == str("peca",i+1):
					peca_index = pecas_atuais.find(pecas_atuais[j])
					break
			var posicao_peca = Vector2i(pecas_atuais.get(peca_index).position / 128)
			posicoes_novas.append(converter(posicao_peca))
		else:
			posicoes_novas.append(converter(posicao))
			
	instanciar(posicoes_novas)

func _process(delta: float):
	var pecas_atuais = get_node(str("Pecas",cont)).get_children()
	
	if resolveu(pecas_atuais):
		var pensamento = pensar(pecas_atuais)
		mover(pensamento[0], pensamento[1])
		print("tete")
		
	
