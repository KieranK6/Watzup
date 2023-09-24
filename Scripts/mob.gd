extends RigidBody2D

var player: Area2D

signal hit

func _ready():
	$AnimatedSprite2D.play("walk")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	var playerPos = player.global_position

	var direction = playerPos - global_position
	
	look_at(playerPos)
	
	linear_velocity = direction.normalized() * 180

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if(body.is_in_group("projectile")):
		queue_free()

