extends Control
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	$IP_host.visible = false;
	$Port_host.visible = false;
	$HostButton.visible = false;
	
	$IP_join.visible = false;
	$Port_join.visible = false;
	$JoinButton.visible = false;
	
	$JoinButton.visible = false;
	
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	pass # Replace with function body.

#These are called by server or clients
func player_connected(id):
	print("Player connected " + str(id))

func player_disconnected(id):
	print("Player disconnected " + str(id))

func connected_to_server():
	print("Connected to server!")
	SendPlayerInformation.rpc($Name.text, multiplayer.get_unique_id())

func connection_failed():
	print("Failed to connect!")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !Global.Players.has(id):
		Global.Players[id] = {
			"name": name,
			"id": id,
			"bubbles": 0,
			"score": 0,
			"hp": 100,
			"invulnerable": false,
		}
	if multiplayer.is_server():
		for i in Global.Players:
			SendPlayerInformation.rpc(Global.Players[i].name, i)

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://Gameplay/Mainscene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func _on_host_dropdown_pressed():
	if $IP_host.visible != true:
		$IP_host.visible = true;
		$Port_host.visible = true;
		$HostButton.visible = true;
	else:
		$IP_host.visible = false;
		$Port_host.visible = false;
		$HostButton.visible = false;

func _on_join_dropdown_pressed():
	if $IP_join.visible != true:
		$IP_join.visible = true;
		$Port_join.visible = true;
		$JoinButton.visible = true;
	else:
		$IP_join.visible = false;
		$Port_join.visible = false;
		$JoinButton.visible = false;

func visible(boolean):
	$IP_join.visible = boolean;
	$Port_join.visible = boolean;
	$JoinButton.visible = boolean;
	$IP_host.visible = boolean;
	$Port_host.visible = boolean;
	$HostButton.visible = boolean;

func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new();
	var host_IP_address = $IP_host.text
	var host_port = $Port_host.text
	
	var error = peer.create_server(host_port.to_int(), 2)
	if error != OK:
		print("Cannot host:" + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players!")
	SendPlayerInformation($Name.text, multiplayer.get_unique_id())
	visible(false)
	$JoinDropdown.visible = false;
	$Players.text += "\n" + "Host: " + Global.Players[1]["name"]


func _on_join_button_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(str($IP_join.text), $Port_join.text.to_int())
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	visible(false)
	$StartGame.visible = false
	await(get_tree().create_timer(2).timeout)
	$Players.text += "\n" + $Name.text

func _on_start_game_pressed():
	StartGame.rpc()
