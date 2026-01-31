class_name MainMenu extends Node2D

@export var round_scene : PackedScene
var round_instance : Round

@onready var server_ip : LineEdit = $%ServerIP 

const CONNECTED : String = "Connected"
const CONNECTION_ISSUE : String = "Connection Issues"
const DISCONNECTED : String = "Not connected"
const HOST : String = "Host"
const HOSTING_ISSUE : String = "Hosting Issues"

@onready var connection_status : Label = $%ConnectionStatus 

@onready var main_menu_canvas : CanvasLayer = $%MainMenuCanvas
@onready var main_menu : Control = $%MainMenu

@export var lobby_entry_scene : PackedScene
@onready var lobby : Control = $%Lobby
@onready var connected_players : Control = $%ConnectedPlayers
@onready var start_round : Button = $%StartRound

func _ready() -> void:
	Lobby.server_disconnected.connect(_on_server_disconnect)
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	switch_to_menu()

func switch_to_menu() -> void:
	main_menu.visible = true
	lobby.visible = false
	for c : Node in connected_players.get_children():
		c.queue_free()
	
func switch_to_lobby() -> void:
	main_menu.visible = false
	lobby.visible = true
	start_round.disabled = not multiplayer.is_server()

func _on_player_connected(peer_id : int, player_name : String) -> void:
	var label : ConnectPlayerLabel = lobby_entry_scene.instantiate() as ConnectPlayerLabel
	label.player_id = peer_id
	label.player_name = player_name
	connected_players.add_child(label)

func _on_player_disconnected(peer_id : int) -> void:
	for l : ConnectPlayerLabel in connected_players.get_children():
		if l.player_id == peer_id:
			connected_players.remove_child(l)
			return

func _on_server_disconnect() -> void:
		connection_status.text = DISCONNECTED
		switch_to_menu()

func _on_host_server_pressed() -> void:
	var error : Error = Lobby.create_server()
	if error:
		connection_status.text = HOSTING_ISSUE
	else:
		connection_status.text = HOST
		switch_to_lobby()
		
func _on_connect_to_server_pressed() -> void:
	var error : Error
	if server_ip.text:
		error = Lobby.connect_client(server_ip.text)
	else:
		error = Lobby.connect_client()
	if error:
		connection_status.text = CONNECTION_ISSUE
	else:
		connection_status.text = CONNECTED
		switch_to_lobby()

func _on_disconnect_pressed() -> void:
	Lobby.remove_multiplayer_peer()
	connection_status.text = DISCONNECTED
	switch_to_menu()
	
func _on_start_round_pressed() -> void:
	if multiplayer.is_server():
		load_round.rpc()

@rpc("call_local", "reliable")
func load_round():
	main_menu_canvas.visible = false
	round_instance = round_scene.instantiate() as Round
	add_child(round_instance)

@rpc("call_local", "reliable")
func free_round():
	round_instance.queue_free()
	main_menu_canvas.visible = true
