extends Node

var networks = {} # network_id: { machines: [], astar: Astar2D, "color": Color }
var machines = {} # machine: network_id
var network_list = [] # network_id
var machine_id_counter = 0 # machine_id


# Adds a machine to the global state.
# 
# Parameters:
#  - machine: The machine instance to be added.
func add_machine(machine):
	if not machines.has(machine):
		machine.id = machine_id_counter
		machine_id_counter += 1
		machine.connect("connections_changed", self, "_on_connections_changed")
		machines[machine] = null

	var neighbors: Array = get_neighbors(machine)
	
	if neighbors.size() > 0:
		for neighbor in neighbors:
			if machines[neighbor] == null: continue
			
			if machines[machine] == null:
				add_to_network(machine, machines[neighbor])
				continue
		
			if machines[neighbor] != machines[machine]:
				merge_networks(machines[machine], machines[neighbor])
	else:
		create_network(machine)

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
		machines[machine] = network_id1
	networks.erase(network_id2)

	network_list.erase(network_id2)
	update_machine_colors(network_id1)
	
func get_neighbors(machine):
	var neighbors = []
	for _machine in machine.neighbors:
		if machines.has(_machine): neighbors.append(_machine)
	return neighbors

func add_to_network(machine, network_id):
	var network = networks[network_id]
	machines[machine] = network_id
	network.machines.append(machine)
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
	var network = {"machines": [machine], "astar": AStar2D.new(), "color": Color(randf(), randf(), randf())}
	networks[network_id] = network
	machines[machine] = network_id
	network.astar.add_point(machine.id, machine.position)
	update_machine_colors(network_id)

func _on_connections_changed(machine):
		add_machine(machine)