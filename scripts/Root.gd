extends Node2D

var machine_pack = preload("res://scenes/Machine.tscn")
var offset = Vector2(32,32)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("click"):
		var pos = get_global_mouse_position().snapped(Vector2(64, 64))
		var name_inst = "machine_%s_%s" % [pos.x, pos.y]
		if not $Machines.has_node(name_inst):
			var inst = machine_pack.instance()
			inst.global_position = pos
			inst.name = name_inst 

			$Machines.add_child(inst)
			print("criou maquina ", name_inst)