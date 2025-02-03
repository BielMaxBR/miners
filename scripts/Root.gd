extends Node2D

var machine_pack = preload("res://scenes/Machine.tscn")
var machine_list = [preload("res://scenes/machines/Conveyor.tscn"), preload("res://scenes/machines/Miner.tscn"), preload("res://scenes/machines/Storage.tscn")]
var offset = Vector2(32,32)

var slot = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = "Slot: %s" % slot
	if Input.is_action_pressed("slot1"):
		slot = 0
	elif Input.is_action_pressed("slot2"):
		slot = 1
	elif Input.is_action_pressed("slot3"):
		slot = 2
	if Input.is_action_pressed("click"):
		var pos = get_global_mouse_position().snapped(Vector2(64, 64))
		var name_inst = "machine_%s_%s" % [pos.x, pos.y]
		if not $Machines.has_node(name_inst):
			var inst = machine_list[slot].instance()
			inst.global_position = pos
			inst.name = name_inst 

			$Machines.add_child(inst)
			# print("criou maquina ", name_inst)