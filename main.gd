extends Node2D

const TILE_SIZE = 32
const GRID_SIZE = 19
const BORDER_SIZE = 16
const PLAY_AREA_START = Vector2(BORDER_SIZE,BORDER_SIZE)
const PLAY_AREA_END = Vector2(BORDER_SIZE+(GRID_SIZE-1)* TILE_SIZE,
BORDER_SIZE+(GRID_SIZE-1)* TILE_SIZE
)

var direction = Vector2.RIGHT
var move_timer = 0.0
var move_delay = 0.2

var snake_body = []
var snake_positions = []
var score = 0

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
	
	$Snake/Head.position = Vector2(
		BORDER_SIZE + 5 * TILE_SIZE,
		BORDER_SIZE + 5 * TILE_SIZE
	)
	snake_positions.clear()
	snake_positions.append($Snake/Head.position)
	score = 0
	update_score()
	move_apple()
   
func move_snake():
	var next_position = snake_positions[0] + direction * TILE_SIZE
	
	# Wall check
	if (
	next_position.x < PLAY_AREA_START.x
	or next_position.y < PLAY_AREA_START.y
	or next_position.x > PLAY_AREA_END.x
	or next_position.y >PLAY_AREA_END.y
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
		eat_apple()

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
	if move_delay > 0.05:	
		move_delay -= 0/01
	score += 1
	update_score()
	$EatSound.stop()
	$EatSound.play()
	move_apple()
	
func move_apple():
	var new_position : Vector2
	
	while true:
		var x = randi_range(0, GRID_SIZE-1) * TILE_SIZE + BORDER_SIZE
		var y = randi_range(0, GRID_SIZE-1) * TILE_SIZE + BORDER_SIZE
		new_position = Vector2(x, y)
	
		if new_position not in snake_positions:
			break
	
	$Apple.position = new_position

func update_score():
	$ScoreLabel.text = "Score: " + str(score)
	
func game_over():
	$GameOverSound.play()
	score = 0
	update_score()
	print("Game Over")
	await get_tree().create_timer(0.6).timeout
	get_tree().reload_current_scene()
	
	
	
