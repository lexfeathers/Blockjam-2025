extends Node2D

@export var shape: String;
var move_tween;
var matched = false

func _ready():
	pass;

func move(target):
	move_tween=self.create_tween()
	move_tween.tween_property(self,"position",target,.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	move_tween.play()

func rotating():
	if Input.is_action_just_pressed("RotateLeft"):
		rotation_degrees += 90
		if rotation_degrees > 180:
			rotation_degrees-= 360;
	
	if Input.is_action_just_pressed("RotateRight"):
		rotation_degrees -= 90
		if rotation_degrees < 180:
			rotation_degrees-= 360;

		
func dim():
	var sprite = get_node("Sprite2D")
	sprite.modulate = Color(1,1,1,.5)
	pass;
