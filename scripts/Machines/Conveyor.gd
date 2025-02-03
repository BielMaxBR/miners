extends Machine


func _physics_process(_delta):
	$Sprite.region_rect.position.x += 1.5
