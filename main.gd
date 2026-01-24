extends Control

@onready var start_screen = $GameRoot/GameUI/StartScreen
@onready var pause_ui = $GameRoot/GameUI/PauseUI
@onready var score_label = $GameRoot/GameUI/ScoreLabel
@onready var snake = $GameRoot/Snake
@onready var snake_head = $GameRoot/Snake/Head
@onready var apple = $GameRoot/Apple
@onready var eat_sound = $GameRoot/EatSound
@onready var game_over_sound = $GameRoot/GameOverSound
@onready var game_music = $GameRoot/GameMusic
@onready var divider = $GameRoot/DividerLine

var game_started := false

const TILE_SIZE = 32
const GRID_SIZE = 19
const BORDER_SIZE = 16

const UI_OFFSET_TILES = 2
const UI_OFFSET = UI_OFFSET_TILES * TILE_SIZE

const PLAY_AREA_START = Vector2(
	BORDER_SIZE,
	BORDER_SIZE + UI_OFFSET
)
const PLAY_AREA_END = Vector2(
	BORDER_SIZE + (GRID_SIZE - 1) * TILE_SIZE,
	BORDER_SIZE + (GRID_SIZE - 1) * TILE_SIZE
)

var direction = Vector2.RIGHT
var move_timer := 0.0
var move_delay := 0.2

var snake_positions = []
var score := 0

func _ready():
	start_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_ui.process_mode = Node.PROCESS_MODE_ALWAYS

	start_screen.visible = true
	pause_ui.visible = false
	get_tree().paused = true

	#print(pause_ui)

	divider.size.y = 2
	divider.position.y = PLAY_AREA_START.y - 2
	snake_head.position = Vector2(
	BORDER_SIZE + 5 * TILE_SIZE,
	BORDER_SIZE + UI_OFFSET + 5 * TILE_SIZE
)


	snake_positions.clear()
	snake_positions.append(snake_head.position)

	score = 0
	update_score()
	move_apple()
	
	# ✅ ONLY connect, DO NOT play here
	if not game_music.finished.is_connected(_on_music_finished):
		game_music.finished.connect(_on_music_finished)

func _on_music_finished():
	if game_started and not get_tree().paused:
		game_music.play()

func _process(delta):
	if not game_started:
		return

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

func start_game():
	game_started = true
	get_tree().paused = false
	start_screen.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and game_started:
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		pause_ui.visible = false
		game_music.play()
	else:
		get_tree().paused = true
		pause_ui.visible = true
		game_music.stop()


func move_snake():
	var next_position = snake_positions[0] + direction * TILE_SIZE

	if (
		next_position.x < PLAY_AREA_START.x
		or next_position.y < PLAY_AREA_START.y
		or next_position.x > PLAY_AREA_END.x
		or next_position.y > PLAY_AREA_END.y
	):
		game_over()
		return

	if next_position.y < PLAY_AREA_START.y:
		game_over()

	snake_positions.insert(0, next_position)

	if next_position != apple.position:
		snake_positions.pop_back()
	else:
		eat_apple()

	update_snake_visuals()

func update_snake_visuals():
	snake_head.position = snake_positions[0]

	for i in range(1, snake_positions.size()):
		if i >= snake.get_child_count():
			var part = ColorRect.new()
			part.size = Vector2(32, 32)
			part.color = Color.GREEN
			snake.add_child(part)

		snake.get_child(i).position = snake_positions[i]

func eat_apple():
	if move_delay > 0.05:
		move_delay -= 0.01
	score += 1
	update_score()
	eat_sound.play()
	move_apple()

func move_apple():
	var max_x_tiles = int((PLAY_AREA_END.x - PLAY_AREA_START.x) / TILE_SIZE)
	var max_y_tiles = int((PLAY_AREA_END.y - PLAY_AREA_START.y) / TILE_SIZE)

	var x = randi_range(0, max_x_tiles - 1) * TILE_SIZE + PLAY_AREA_START.x
	var y = randi_range(0, max_y_tiles - 1) * TILE_SIZE + PLAY_AREA_START.y

	var new_position = Vector2(x, y)

	# prevent spawning on snake
	while new_position in snake_positions:
		x = randi_range(0, max_x_tiles - 1) * TILE_SIZE + PLAY_AREA_START.x
		y = randi_range(0, max_y_tiles - 1) * TILE_SIZE + PLAY_AREA_START.y
		new_position = Vector2(x, y)

	apple.position = new_position

func update_score():
	score_label.text = "Score: " + str(score)

func game_over():
	game_music.stop()
	game_over_sound.play()

	await get_tree().create_timer(0.6).timeout
	get_tree().reload_current_scene()


func _on_start_button_pressed():
	game_started = true
	get_tree().paused = false

	start_screen.visible = false
	pause_ui.visible = false

	game_music.play()


func _on_resume_button_pressed():
	get_tree().paused = false
	pause_ui.visible = false
	game_music.play()
