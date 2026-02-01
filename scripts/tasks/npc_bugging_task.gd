class_name NPCBuggingTask extends Node2D

signal finished_bugging()

@export var bugging_increase_rate: float = 25
@export var bugging_decline_rate: float = 5
var bugged_porcentage: float = 0

@onready var progress : TextureProgressBar = $%Progress

var player_inside_bugging_area : bool = false

func _process(delta: float) -> void:
	progress.value = bugged_porcentage
	if bugged_porcentage >= 100:
		return
	if player_inside_bugging_area:
		bugged_porcentage += bugging_increase_rate * delta
		if bugged_porcentage >= 100:
			print("bugged npc!")
			finished_bugging.emit(self)
	else:
		bugged_porcentage -= bugging_decline_rate * delta
		if bugged_porcentage < 0:
			bugged_porcentage = 0

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
