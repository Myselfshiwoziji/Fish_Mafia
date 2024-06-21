extends Node

var time_left = 999

var p1_player_hp = 100
var p1_player_bubbles = 0
var p1_player_score = 0
var p1_invunerable = false

var p2_player_hp = 100
var p2_player_bubbles = 0
var p2_player_score = 0
var p2_invunerable = false

func _ready():
	p1_player_hp = 100
	p1_player_bubbles = 0
	p1_player_score = 0
	p1_invunerable = false
	
	p2_player_score = 0
	p2_invunerable = false
