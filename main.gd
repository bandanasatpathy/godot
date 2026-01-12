extends Node2D

const TILE_SIZE = 32

var direction = Vector2.RIGHT
var move_timer = 0.0
const move_delay = 0.2

var snake_body = []
var snake_positions = []

func _process(delta) :
	handle_input()
	move_timer += delta
	if move_timer >= move_delay:
		move_timer = 0
		move_snake()
	
func handle_input():
	if Input.is_action_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT

func _ready():
	snake_positions.append($Snake/Head.position)
   
func move_snake():
	var next_position = snake_positions[0] + direction * TILE_SIZE
	
	# Wall check
	if (
		next_position.x < 0
		or next_position.y < 0
		or next_position.x >= 640
		or next_position.y >= 640
	):
		game_over()
		return	
	
	# Self collision
	if next_position in snake_positions:
		game_over()
		return

	# Insert new head position
	snake_positions.insert(0, next_position)

	# Remove last position (unless eating apple)
	if next_position != $Apple.position:
		snake_positions.pop_back()
	else:
		move_apple()

	update_snake_visuals()
		

func update_snake_visuals():
	$Snake/Head.position = snake_positions[0]
	for i in range(1, snake_positions.size()):
		if i >= $Snake.get_child_count():
			var part = ColorRect.new()
			part.size = Vector2(32, 32)
			part.color = Color.GREEN
			$Snake.add_child(part)

		$Snake.get_child(i).position = snake_positions[i]

func eat_apple():
	spawn_new_body_part()
	move_apple()
	
func spawn_new_body_part():
	var body_part = ColorRect.new()
	body_part.size = Vector2(32,32)
	body_part.color = Color.GREEN
	body_part.position = snake_body[snake_body.size() - 1].position
	
	$Snake.add_child(body_part)
	snake_body.append(body_part)
	
func move_apple():
	var x = randi_range(0, 19) * TILE_SIZE
	var y = randi_range(0, 19) * TILE_SIZE
	$Apple.position = Vector2(x, y)

	
func game_over():
	print("Game Over")
	get_tree().reload_current_scene()
	
	
	
