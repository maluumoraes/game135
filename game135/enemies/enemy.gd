class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 10
@export var death_prefab: PackedScene
@export var damage_digit_prefab: PackedScene
@export var monsters_defeated_counter: int
@onready var damage_digit_marker = $DamageDigitMarker

@export_category("Drops")
@export var drop_chances: float = 0.1
@export var drop_itens: Array[PackedScene]


func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)
	
	# Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Criar DamageDigit
	if damage_digit_prefab:
		var damage_digit = damage_digit_prefab.instantiate()
		damage_digit.value = amount
		if damage_digit_marker:
			damage_digit.global_position = damage_digit_marker.global_position 
		else:
			damage_digit.global_position = global_position
		get_parent().add_child(damage_digit)
	else:
		print("damage_digit_prefab não carregado corretamente")
	
	# Processar a morte
	if health <= 0:
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	# Incrementar contador
	GameManager.monsters_defeated_counter += 1
	
	drop_item()
	queue_free()

func drop_item() -> void:
	if randf() < drop_chances:
		if drop_itens.size() > 0:
			var random_index = randi() % drop_itens.size()
			var drop_item = drop_itens[random_index].instantiate()
			drop_item.position = position
			get_parent().add_child(drop_item)
		else:
			print("Nenhum item para dropar.")
	else:
		print("Nenhum item dropar desta vez.")
