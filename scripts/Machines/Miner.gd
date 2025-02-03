extends Machine

func _enter_tree():
    type = Global.MachineType.MINER

func _physics_process(_delta):
    $Sprite.rotation_degrees += 2