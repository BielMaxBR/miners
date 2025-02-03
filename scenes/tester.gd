extends Node2D

var speed = 300
var path = []

func _physics_process(delta):
	if path.size() > 0:
		var next_point = path[0]
		var direction = (next_point - global_position).normalized()
		global_position += direction * speed * delta

		if position.distance_to(next_point) < 5:
			path.remove(0)
	else:
		queue_free()
