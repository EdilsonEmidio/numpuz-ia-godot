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
var cont: int = 0
var peca_mexida: int = -1
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
	if pecas[0].position == posicoes[0] * 128 and \
	pecas[1].position == posicoes[1] *128 and \
	pecas[2].position == posicoes[2] * 128 and \
	pecas[3].position == posicoes[3] * 128 and \
	pecas[4].position == posicoes[4] * 128 and \
	pecas[5].position == posicoes[5] * 128 and \
	pecas[6].position == posicoes[6] * 128 and \
	pecas[7].position == posicoes[7] * 128:
		print("acabou!")
		flag = false
	return flag

func instanciar(pecas: Array):
	cont += 1
	var pecas_atuais = preload("res://cenas/pecas.tscn").instantiate()
	pecas_atuais.name = str("Pecas",cont)
	pecas_atuais.gerar(pecas)
	pecas_atuais.position += Vector2(0, 512*cont)
	pecas_atuais.ready
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
func to_vetor(numero: int)-> Vector2i:
	var vetor
	match numero:
		1:
			vetor = Vector2i(1,1)
		2:
			vetor = Vector2i(2,1)
		3:
			vetor = Vector2i(3,1)
		4:
			vetor = Vector2i(1,2)
		5:
			vetor = Vector2i(2,2)
		6:
			vetor = Vector2i(3,2)
		7:
			vetor = Vector2i(1,3)
		8:
			vetor = Vector2i(2,3)
	return vetor

func buscar_peca(posicao: Vector2)-> Sprite2D:
	var pecas = get_node(str("Pecas",cont)).get_children()
	for i in pecas.size():
		if pecas[i].position/128 == posicao:
			return pecas[i]
	return null

func to_dicionario(pecas: Array)-> Dictionary:
	var dicionario: Dictionary = {
		1:Vector2(1,1),
		2:Vector2(2,1),
		3:Vector2(3,1),
		4:Vector2(1,2),
		5:Vector2(2,2),
		6:Vector2(3,2),
		7:Vector2(1,3),
		8:Vector2(2,3)}
	
	for i in pecas.size():
		dicionario[i+1] = Vector2(pecas[i].position/128)
	return dicionario

func pontuar(pecas: Dictionary, vazio: Vector2, saltos: int, ultima_peca: int)-> Array:
	var array: Array
	array.resize(2)
	var posicoes_validas = posicoes_validas(vazio)
	if ultima_peca != -1:
		posicoes_validas.erase(pecas[ultima_peca])
	var pontos: Array
	var menor_pontuacao: int = 99999
	var menor_pontuador: Vector2
	var peca_numero: int
	pontos.resize(posicoes_validas.size())
	for i in posicoes_validas.size():
		if saltos==0:
			return Array([(0.0),0])
		peca_numero = pecas.find_key(posicoes_validas[i])
		var posicao_origem = to_vetor(peca_numero)
		pontos[i] = abs(vazio.x - posicao_origem.x)
		pontos[i] += abs(vazio.y - posicao_origem.y)
		
		var pecas_clone: Dictionary = Dictionary(pecas).duplicate()
		var vazio_clone = pecas_clone[peca_numero]
		pecas_clone[peca_numero] = vazio #referencia clone
		var resultado: Array = pontuar(pecas_clone, vazio_clone, saltos-1, peca_numero)
		pontos[i] += resultado[1]
	for i in posicoes_validas.size():
		if peca_mexida != pecas.find_key(posicoes_validas[i]) and menor_pontuacao > pontos[i]:
			menor_pontuacao = pontos[i]
			menor_pontuador = posicoes_validas[i]
	array[0] = menor_pontuador
	array[1] = menor_pontuacao
	return array

func procurar_numero(posicao: Vector2, pecas_atuais: Array) -> String:
	for i in pecas_atuais.size():
		if pecas_atuais[i].position/128 == posicao:
			return pecas_atuais[i].name.get_slice("a",1)
	return ""

func pensar(pecas: Array) -> Array:
	var pontuador: Sprite2D
	var posicao_livre = get_node(str("Pecas",cont)).posicoes_livres[0]
	var vetor_livre = get_node(str("Pecas",cont)).posicoes[posicao_livre]
	var posicoes_validas = posicoes_validas(vetor_livre)
	
	var pecas_dicionario = to_dicionario(pecas)
	var resultado = pontuar(pecas_dicionario, vetor_livre, 7, -1)
	pontuador = buscar_peca(resultado[0])
	
	return Array([pontuador, vetor_livre])

func converter(vetor: Vector2i) -> int:
	var posicao
	match vetor:
		Vector2i(1, 1):
			posicao = 0
		Vector2i(2, 1):
			posicao = 1
		Vector2i(3, 1):
			posicao = 2
		Vector2i(1, 2):
			posicao = 3
		Vector2i(2, 2):
			posicao = 4
		Vector2i(3, 2):
			posicao = 5
		Vector2i(1, 3):
			posicao = 6
		Vector2i(2, 3):
			posicao = 7
		Vector2i(3, 3):
			posicao = 8
	
	return posicao

func mover(peca: Sprite2D, posicao: Vector2i):
	peca_mexida = peca.numero
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
	
	if resolveu(pecas_atuais) and cont<500:
		var pensamento = pensar(pecas_atuais)
		mover(pensamento[0], pensamento[1])
	
