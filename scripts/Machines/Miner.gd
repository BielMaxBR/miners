extends Machine

var timer = Timer.new()
var tester_pack = preload("res://scenes/tester.tscn")

func _enter_tree():
    add_child(timer)
    type = Global.MachineType.MINER
    timer.connect("timeout", self, "_on_timeout")
    timer.start(1)
    timer.autostart = true

func _physics_process(_delta):
    $Sprite.rotation_degrees += 2

func _on_timeout():
    var network_id = Global.machines[id].network_id
    var net = Global.networks[network_id]
    var storages = net.types[Global.MachineType.STORAGE]
    if not storages: return
    var storage_path = []
    for _storage in storages:
        var new_path = net.astar.get_point_path(id, _storage.id)
        if new_path.size() < storage_path.size() or storage_path.size() == 0:
            storage_path = new_path
    print(network_id," ", net.types[Global.MachineType.STORAGE].size())
    if storage_path.size() == 0: return
    var new_tester = tester_pack.instance()
    new_tester.path = storage_path
    new_tester.global_position = global_position
    get_parent().get_parent().add_child(new_tester)