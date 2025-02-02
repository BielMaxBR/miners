extends Node

var networks = {} # network_id: { machines: [], astar: Astar2D, "color": Color }
var machines = {} # machine: network_id
var network_list = []
var network_id_counter = 0
var machine_id_counter = 0

func add_machine(machine, network_id = null):
	if not machines.has(machine):
		machine.id = machine_id_counter
		machine_id_counter += 1
		machine.connect("connections_changed", self, "_on_connections_changed")

	if network_id:
		add_to_network(machine, network_id)
		return

	var neighbors: Array = get_neighbors(machine)

	if neighbors.size() > 0:
		var network_id_neighbor = machines[neighbors[0]]
		if not machines.has(machine):
			add_to_network(machine, network_id_neighbor)
		else:
			if network_id_neighbor == machines[machine]: return
			merge_networks(machines[machine], network_id_neighbor)
	else:
		create_network(machine)

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
	# print("connections changed for ", machine.name)
	if machine.neighbors.size() > 0:
		for neighbor in machine.neighbors:
			if machines[neighbor]:
				if machines[machine] == null:
					add_machine(machine, machines[neighbor])
				else:
					if machines[neighbor] != machines[machine]:
						merge_networks(machines[machine], machines[neighbor])
	else:
		add_machine(machine)
	# print("fim connections changed")