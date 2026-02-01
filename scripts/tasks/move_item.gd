class_name MoveItem extends Node2D

signal finished_item_taken()

@export var round : Round

@export var item_take_rate: float = 25
@export var item_take_decline_rate: float = 5
var item_take_porcentage: float = 0

@export var item_id : int = 0

@onready var progress : TextureProgressBar = $%Progress

var player_inside_bugging_area : bool = false

func _process(delta: float) -> void:
	if round.player_role == PlayerControl.PLAYER_ROLE.DETECTIVE:
		progress.visible = false
	progress.value = item_take_porcentage
	if item_take_porcentage >= 100:
		return
	if player_inside_bugging_area:
		item_take_porcentage += item_take_rate * delta
		if item_take_porcentage >= 100:
			print("bugged npc!")
			finished_item_taken.emit(self)
	else:
		item_take_porcentage -= item_take_decline_rate * delta
		if item_take_porcentage < 0:
			item_take_porcentage = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player : PlayerControl = body as PlayerControl
	if player and player.role == PlayerControl.PLAYER_ROLE.SPY\
			  and player.player == multiplayer.get_unique_id():
		player_inside_bugging_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	var player : PlayerControl = body as PlayerControl
	if player and player.role == PlayerControl.PLAYER_ROLE.SPY\
			  and player.player == multiplayer.get_unique_id():
		player_inside_bugging_area = false
