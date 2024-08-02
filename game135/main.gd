extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene


func trigger_game_over():
	# Deletar GameUI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
		# Verificar se game_over_ui_template não é null
	if game_over_ui_template:
		var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
		add_child(game_over_ui)
	else:
		print("game_over_ui_template não está atribuído!")
	
