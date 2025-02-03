extends Machine


onready var tween: Tween = $Tween
func _enter_tree():
    type = Global.MachineType.STORAGE

func _ready():
    tween.interpolate_property($Sprite, "scale", Vector2(0.9,0.9), Vector2(1,1), 0.8,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
    tween.start()