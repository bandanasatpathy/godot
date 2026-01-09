extends Node2D

const TILE_SIZE = 32

var direction = Vector2.RIGHT
var move_timer = 0.0
const move_delay = 0.2

func _process(delta):
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
	elif  Input.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT
		
func move_snake():
	var next_position = $Snake/Head.position + direction * TILE_SIZE

	if (
		next_position.x < 0
		or next_position.y < 0
		or next_position.x >= 640
		or next_position.y >= 640
	):
		game_over()
		return
	$Snake/Head.position = next_position
func game_over():
	print("Game over")
	get_tree().reload_current_scene()
	 
	 
