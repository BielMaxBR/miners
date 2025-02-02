extends Area2D
class_name Machine

signal connections_changed
var neighbors = []
var id = null
var color = Color(1,1,1)

func _ready():
	Global.add_machine(self)

func _process(_delta):
	if $Sprite.modulate != color:
		$Sprite.modulate = color

func _on_Area2D_area_entered(area):
	if not neighbors.has(area) and area != self:
		neighbors.append(area)
		emit_signal("connections_changed", self)
		# Global.add_machine(self)

func _on_Area2D_area_exited(area):
	if neighbors.has(area) and area != self:
		neighbors.erase(area)
		emit_signal("connections_changed", self)
	
