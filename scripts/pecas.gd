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
var posicoes_livres = [0,1,2,3,4,5,6,7,8]
var pecas: Array

func posicao_grade(i: int) -> Vector2:
	return posicoes[i] * 128


func gerar(input: Array):
	pecas = get_children()
	for i in 8:
		pecas[i].position = posicao_grade(input[i])
		
func gerar_aleatorio():
	pecas = get_children()
	for i in 8:
		var rand = randi_range(0,posicoes_livres.size()-1)
		var posicao = posicoes_livres[rand]
		posicoes_livres.remove_at(rand)
		pecas[i].position = posicao_grade(posicao)
