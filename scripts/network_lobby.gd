class_name NetworkLobby extends Node

@export var game_scene : PackedScene

signal player_connected(peer_id : int, player_name : String)
signal player_disconnected(peer_id : int)
signal server_disconnected

const MAX_CLIENTS : int = 4
const PORT : int = 7000
const DEFAULT_SERVER_IP = "127.0.0.1"

var player_name : String = "Ernesto"
var connected_players : Dictionary[int, String] = {}

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_server(port: int = PORT)  -> Error:
	var peer = ENetMultiplayerPeer.new()
	var error : Error = peer.create_server(port, MAX_CLIENTS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	connected_players[1] = player_name
	return OK

func connect_client(address: String = DEFAULT_SERVER_IP, port: int = PORT) -> Error:
	var peer = ENetMultiplayerPeer.new()
	var error : Error = peer.create_client(address, port)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	return OK

func remove_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	
func _on_player_connected(id : int):
	_register_player.rpc_id(id, player_name)

@rpc("any_peer", "reliable")
func _register_player(new_player_name : String):
	var new_player_id = multiplayer.get_remote_sender_id()
	connected_players[new_player_id] = new_player_name
	player_connected.emit(new_player_id, new_player_name)

#@rpc("call_local", "reliable")
#func start_game():
	#get_tree().change_scene_to_file()


# Every peer will call this when they have loaded the game scene.
#@rpc("any_peer", "call_local", "reliable")
#func player_loaded():
#	if multiplayer.is_server():
#		players_loaded += 1
#		if players_loaded == players.size():
#			$/root/Game.start_game()
#			players_loaded = 0

func _on_player_disconnected(id : int):
	connected_players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	connected_players[peer_id] = player_name
	player_connected.emit(peer_id, player_name)

func _on_connected_fail():
	remove_multiplayer_peer()

func _on_server_disconnected():
	remove_multiplayer_peer()
	connected_players.clear()
	server_disconnected.emit()
