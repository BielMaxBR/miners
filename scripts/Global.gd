extends Node

var networks = {} # network_id: { machines: [], astar: Astar2D, "color": Color }
var machines = {} # machine_id: { network_id: null, machine: null }
var network_list = [] # network_id
var machine_id_counter = 0 # machine_id

enum MachineType  {
	CONVEYOR,
	MINER,
	STORAGE
}

# Adds a machine to the global state.
# 
# Parameters:
#  - machine: The machine instance to be added.
func add_machine(machine):
	if not machines.has(machine.id):
		machine.id = machine_id_counter
		machine_id_counter += 1
		machine.connect("connections_changed", self, "_on_connections_changed")
		machines[machine.id] = {"network_id": null, "machine": machine}

	var neighbors: Array = get_neighbors(machine)
	
	if neighbors.size() > 0:
		for neighbor in neighbors:
			if machines[neighbor.id].network_id == null: continue
			
			if machines[machine.id].network_id == null:
				add_to_network(machine, machines[neighbor.id].network_id)
				connect_points(machine, neighbor)
				continue
		
			if machines[neighbor.id].network_id != machines[machine.id].network_id:
				merge_networks(machines[machine.id].network_id, machines[neighbor.id].network_id)
				connect_points(machine, neighbor)
				continue

	else:
		create_network(machine)
	# var types = networks[machines[machine.id].network_id].types

	# for type in MachineType.values():
	# 	# if types[type].size() > 0:
	# 	print("Type: ", MachineType.keys()[type], " Size: ", types[type].size())

func connect_points(point1, point2):
	var machine_data = machines[point1.id]
	# print(machine_data)
	var network = networks[machine_data.network_id]
	network.astar.connect_points(point1.id, point2.id, true)

	# var path = network.astar.get_id_path(network.astar.get_points()[0], point1.id)
	# print("Path from first point to point1: ", path)

# Merges two networks identified by their IDs.
# 
# This function takes two network IDs as input and merges the networks
# associated with these IDs into a single network. The specifics of how
# the networks are merged depend on the implementation details within
# the function.
#
# @param network_id1: The ID of the first network to be merged.
# @param network_id2: The ID of the second network to be merged.
# @return: The function does not return a value.
func merge_networks(network_id1, network_id2):
	var network1 = networks[network_id1]
	var network2 = networks[network_id2]
	if network2.machines.size() > network1.machines.size():
		var acc = network_id1
		network_id1 = network_id2
		network_id2 = acc
		network1 = networks[network_id1]
		network2 = networks[network_id2]
	
	for machine in network2.machines:
		add_to_network(machine, network_id1)
		machines[machine.id].network_id = network_id1
	networks.erase(network_id2)

	network_list.erase(network_id2)
	update_machine_colors(network_id1)
	
func get_neighbors(machine):
	var neighbors = []
	for _machine in machine.neighbors:
		if machines.has(_machine.id): neighbors.append(_machine)
	return neighbors

func add_to_network(machine, network_id):
	var network = networks[network_id]
	machines[machine.id].network_id = network_id
	network.machines.append(machine)
	network.types[machine.type].append(machine)
	network.astar.add_point(machine.id, machine.position)

	update_machine_colors(network_id)

func update_machine_colors(network_id):
	var network = networks[network_id]
	for machine in network.machines:
		machine.color = network.color

# Creates a network for the given machine.
# 
# This function initializes and sets up a network for the specified machine.
#
# @param machine: The machine for which the network is to be created.
# @return: void
func create_network(machine):
	var network_id = 0
	while network_list.has(network_id):
		network_id += 1
	network_list.append(network_id)
	var network = {"machines": [machine], "types": {}, "astar": AStar2D.new(), "color": Color(randf(), randf(), randf())}
	for type in MachineType.values():
		network.types[type] = []
	network.types[machine.type].append(machine)

	networks[network_id] = network
	machines[machine.id].network_id = network_id
	network.astar.add_point(machine.id, machine.position)
	update_machine_colors(network_id)

func _on_connections_changed(machine):
		add_machine(machine)
