extends Area2D

@export var SPEED: int = 100

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()

func _on_area_entered(area):
	if(area.name != "Player"):
		destroy() 

func _on_body_entered(body):
	if(body.name == "Player"):
		pass
		
	elif (body.is_in_group("mobs")):
		body.queue_free()
		var parent = get_parent() as Node2D
		parent.on_hit()
		destroy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

