extends CharacterBody2D
signal hit	

@export var speed = 500
@export var jumpheight = 50
@export var respawntime = 3
@export var projectile_speed = 500

var screen_size 
var frames_since_grounded = 0
var in_damage = false
var dead = false
var spawn_location = Vector2.ZERO
@export var projectile_scene : PackedScene

var glock_loaded = true
var true_direction = 90
var dash = true

func _ready():
	screen_size = get_viewport_rect().size;
	get_tree().call_group("projectile", "queue_free")
	spawn_location = self.global_position
	
	$Animation.modulate = Color(0.7, 1, 1)
	

func movement():
	var direction := Vector2.ZERO
	velocity.y += 30
	var xvel = 0
	
	if is_on_floor() == true:
		frames_since_grounded = 0
	
	else:
		frames_since_grounded += 1
	
	if Input.is_action_pressed("p2_left"):
		xvel -= 1
		direction.x -= 1
		
	if Input.is_action_pressed("p2_right"):
		xvel += 1
		direction.x += 1
	
	if Input.is_action_just_pressed("p2_dash") && dash == true:
		xvel = xvel * 30
		if Input.is_action_pressed("p2_up"):
			velocity.y = -abs(velocity.y * 2)
		dash = false
		$DashTimer.start()
	
	velocity.x = xvel * speed
	
	if Input.is_action_pressed("p2_up") and frames_since_grounded < 10:
			velocity.y = jumpheight * -1
		
	#rotation code
	if direction.x != 0:
		$Animation.flip_h = direction.x < 0  # Flip the sprite horizontally based on the direction
		$Animation.rotation = 0
		
		if direction.x < 0:
			true_direction = 1
		else:
			true_direction = -1
	
	# animation code
	if is_on_floor() == true:
		if not xvel == 0:
			$Animation.play("walk")
		else:
			$Animation.play("Idle")
	else:
		$Animation.play("Fall")

func aiming():
	var aim_location = Vector2.ZERO;
	if Input.is_action_pressed("p2_aimup"):
		aim_location.y = -1
	if Input.is_action_pressed("p2_aimdown"):
		aim_location.y = 1
	if Input.is_action_pressed("p2_aimleft"):
		aim_location.x = 1
	if Input.is_action_pressed("p2_aimright"):
		aim_location.x = -1
	
	if aim_location == Vector2.ZERO:
		aim_location.x = true_direction
	
	if aim_location.x > 0:
		$Gun.flip_h = true
		$Gun.global_position = $Animation/GunLoc.global_position + Vector2(-50,0)
	else:
		$Gun.flip_h = false
		$Gun.global_position = $Animation/GunLoc.global_position
	#$Gun.rotation = aim_location.angle()
	
	return aim_location

func action(direction):
	if Input.is_action_pressed("p2_action") and glock_loaded == true:
		glock_loaded = false
		
		var projectile = projectile_scene.instantiate();
		var projectile_spawn = self.global_position
		projectile.position = projectile_spawn
		projectile.current_owner = 2
		var projectile_rotation = -1 * direction.angle_to_point(Vector2(0,0))
		projectile.rotate(projectile_rotation)
		get_parent().add_child(projectile)
		
		$Gun.play("Shoot")
		
		$GlockCD.start()



func _physics_process(delta):
	if dead == false:
		action(aiming())
		
		movement()
		
		move_and_slide()
		
		if Global.p2_player_hp <= 0:
			self.visible = false
			dead = true
			Global.p2_invunerable = true
			
			await(get_tree().create_timer(respawntime).timeout)
			
			dead = false
			self.visible = true
			Global.p2_player_hp = 100
			Global.p2_player_bubbles = 0
			self.global_position = spawn_location
			
			await(get_tree().create_timer(2).timeout)
			
			Global.p2_invunerable = false


func _on_hitbox_body_entered(body):
	in_damage = true
	$DamageTimer.start()
	if Global.p2_invunerable == false:
		Global.p2_player_hp -= 10


func _on_hitbox_body_exited(body):
	in_damage = false


func _on_damage_timer_timeout():
	if in_damage == true:
		if Global.p1_invunerable == false:
			Global.p2_player_hp -= 10
			$DamageTimer.start()


func _on_glock_cd_timeout():
	glock_loaded = true


func _on_dash_timer_timeout():
	dash = true
