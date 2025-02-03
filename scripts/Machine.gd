extends Area2D
class_name Machine

signal connections_changed
var neighbors = []
var id = null
var color = Color(1,1,1)

const SLOT_CAPACITY = 5

enum Direction {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_RIGHT,
	BOTTOM_LEFT
}

class Slot:
	var items = []
	var neighbor = null

	func add_item(item):
		if items.size() < SLOT_CAPACITY:
			items.append(item)
		else:
			# Handle overflow, maybe drop the item or return false
			pass

	func remove_item():
		if items.size() > 0:
			return items.pop_front()
		return null

var slots = {
	Direction.TOP_LEFT: Slot.new(),
	Direction.TOP_RIGHT: Slot.new(),
	Direction.BOTTOM_RIGHT: Slot.new(),
	Direction.BOTTOM_LEFT: Slot.new()
}

func set_neighbor(direction, neighbor_machine):
	slots[direction].neighbor = neighbor_machine

func transfer_item(direction, item):
	var slot = slots[direction]
	if slot.neighbor:
		var neighbor_slot = slot.neighbor.slots[(direction + 1) % 4]
		if neighbor_slot.items.size() < SLOT_CAPACITY:
			slot.remove_item()
			neighbor_slot.add_item(item)

export var type = Global.MachineType.CONVEYOR

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
	
