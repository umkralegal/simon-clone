extends Panel


enum States {
	NOT_PLAYING,
	GENERATING,
	PLAYER_TURN,
	GAME_OVER,
}

var level = 0
var sequence_original = []
var sequence_show = []
var sequence_player = []
var game_state: int = States.NOT_PLAYING
var matches = 0
var record = 0

onready var square_1 = $GridContainer/Square1
onready var square_2 = $GridContainer/Square2
onready var square_3 = $GridContainer/Square3
onready var square_4 = $GridContainer/Square4
onready var grid = $GridContainer
onready var timer = $Timer
onready var level_label = $LevelLabel
onready var info_label = $InfoLabel
onready var info_button = $InfoButton
onready var squares = [square_1, square_2, square_3, square_4]


func _ready():
	randomize()


func click(button):
	button = squares[button]
	match game_state:
		States.NOT_PLAYING:
			level_label.text = "Game starting..."
			for square in squares:
				square.blink(Color.green)
			gen_sequence()

		States.PLAYER_TURN:
			if button == sequence_player[0]:
				button.blink(Color.green)
				sequence_player.remove(0)
				matches += 1
				level_label.text = "Level: %d - [%d / %d]" % [level, matches, level]
				if sequence_player.size() == 0:
					level_label.text = "Level: %d - [%d / %d] COMPLETED!" % [level, matches, level]
					gen_sequence()
			else:
				game_state = States.GAME_OVER
				for square in squares:
					square.blink(Color.red)
				if level >= record:
					record = level
				level_label.text = "GAME ENDED IN LEVEL %d - YOUR RECORD: LEVEL %d" % [level, record]
				level = 0
				sequence_original = []
				sequence_player = []
				sequence_show = []
				timer.start(3)


func gen_sequence():
	game_state = States.GENERATING
	level += 1
	sequence_original.append(squares[randi() % squares.size()])
	sequence_show = sequence_original.duplicate()
	timer.start(1)


func _on_Timer_timeout():
	match game_state:
		States.GAME_OVER:
			game_state = States.NOT_PLAYING
			level_label.text = "Click any square to start"

		States.GENERATING:
			if not sequence_show.size() == 0:
				level_label.text = "Level: " + str(level)
				sequence_show[0].blink(Color.white)
				sequence_show.remove(0)
				timer.start(1)

			else:
				matches = 0
				level_label.text = "Your turn - Level: %d - [0 / %d]" % [level, level]
				sequence_player = sequence_original.duplicate()
				game_state = States.PLAYER_TURN


func _on_InfoButton_pressed():
	var tru: bool = true if info_label.visible else false # yes i'm lazy
	get_tree().paused = not tru
	info_button.text = "Credits and license" if tru else "Return"
	info_label.visible = not tru
	level_label.visible = tru
	grid.visible = tru
