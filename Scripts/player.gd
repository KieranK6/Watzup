extends Area2D
signal hit

@export var SPEED = 400 # How fast the player will move (pixels/sec).
@export var PROJECTILE: PackedScene

var screen_size # Size of the game window.
var isShooting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left") || Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") || Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite2D.play()
	else:
		if isShooting == false:
			$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	if Input.is_action_just_pressed("shoot"):
		var projectile_direction = self.global_position.direction_to(get_global_mouse_position())
		shoot(projectile_direction)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func shoot(projectile_direction: Vector2):
	if(PROJECTILE):
		isShooting = true
		var projectile = PROJECTILE.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = self.global_position
		
		var projectile_rotation = projectile_direction.angle()
		projectile.rotation = projectile_rotation
		
		$AnimatedSprite2D.play("shoot")

func _on_body_entered(body):
	hide() # Player disappears after being hit.
	body.queue_free()
	var parent = get_parent() as Node2D
	parent.on_death()
	hit.emit()
	body.queue_free()
	var mobs = get_tree().get_nodes_in_group("mobs")
	for child in mobs:
		child.queue_free()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)



func _on_hud_shoot_button(position):
	var projectile_direction = self.global_position.direction_to(position)
	shoot(projectile_direction)


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "shoot":
		isShooting = false
