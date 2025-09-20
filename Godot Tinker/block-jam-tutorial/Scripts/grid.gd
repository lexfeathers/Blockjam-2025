extends Node2D

#Grid Size
@export var grid_size := Vector2i(8, 9)
#Tile Size
@export var tile_size := Vector2(20,20)
#Tile Speed
@export var tile_speed: float = 2
#How much Grace Time
@export var grace_time : float = 0.3

#Not sure what this does
var grid: Array
#Tile Position
var tile_position: Vector2
#Tile Shape
var tile_shape: Color
#Grace Timer
var grace_timer: float

#Available Tile
var possible_tiles= [
	preload("res://Scenes/str8_tile.tscn"),
	preload("res://Scenes/term_tile.tscn"),
	preload("res://Scenes/bend_tile.tscn"),
];

func _ready() -> void:
	grid = []
	grid.resize(grid_size.x * grid_size.y)
	create_tile()
	
	
func create_tile() -> void:
	tile_position = Vector2(grid_size.x / 2, -1)
	tile_shape = Color.from_hsv(randf(), .3, .8)

func _process(delta: float) -> void:
	var old_tile_position : Vector2 = tile_position
	var down_multiplier = 5 if Input.is_action_pressed("ui_down") else 1
	tile_position.y += tile_speed * down_multiplier * delta
	if get_grid(floori(tile_position.x), ceili(tile_position.y)):
		tile_position.y = ceili(old_tile_position.y)
		grace_timer -= delta
		if grace_timer < 0:
			if ceili(old_tile_position.y) <0:
				print ("Game over...")
				queue_free()
			set_grid(floori(old_tile_position.x),ceili(old_tile_position.y),tile_shape)
			create_tile()
			
	else:
	#Reset grace timer
		grace_timer = grace_time
	
	if Input.is_action_just_pressed("ui_left"):
		tile_position.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		tile_position.x += 1
	if get_grid(floori(tile_position.x), ceili(tile_position.y)):
		tile_position.x = old_tile_position.x
		
	# If moved, reset grace timer.
	if tile_position.x != old_tile_position.x:
		grace_timer = grace_time
	queue_redraw()

func _draw() -> void:
	# Draw the falling tile.
	draw_rect(Rect2(tile_position * tile_size, tile_size), tile_shape)
	# Draw the map.
	for x in grid_size.x:
		for y in grid_size.y:
			var tile = get_grid(x, y)
			if tile != null:
				draw_rect(Rect2(Vector2(x, y) * tile_size, tile_size), tile)
	# Draw the borders.
	draw_rect(Rect2(Vector2.ZERO, Vector2(grid_size) * tile_size), Color.WHITE, false)
	

func get_grid(x : int, y : int):
	# Pretend to have solid walls all around the area.
	if x < 0 or x >= grid_size.x or y >= grid_size.y:
		return Color.WHITE
	# Above the playing area is empty.
	if y < 0:
		return null
	return grid[x + y * grid_size.x]


	
func set_grid(x : int, y : int, value) -> void:
	if x < 0 or x >= grid_size.x or y < 0 or y >= grid_size.y:
		return
	grid[x + y * grid_size.x] = value
