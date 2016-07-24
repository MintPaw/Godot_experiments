# Frame 0 = stand
# Frame 1 = fire
# Frames 2->6->2 = run loop

extends AnimatedSprite

var animName = "idle"
var tempElapsed = 0
var runElapsed = 0
var run_loop = 0
var shot_fired = 0
var pos = get_pos()
var speed = Vector2(10, 10)
#run_loop == 0 if not running
#run_loop = 1 if cycling 2->6
#run_loop == -1 if cycling 6->2
var direction = 1
#direction == 1 if going right
#direction == -1 if going left
func _ready():
	set_process_input(true)
	set_process(true)

func _process(delta):
	runElapsed += delta
	#If the player is running right
	if Input.is_action_pressed("run_right"):
		if direction == -1:
			direction = 1
			self.set_flip_h(false)
		#runElapsed for smoother running
		if runElapsed > 0.05:
			runElapsed = 0
			pos.x += speed.x
			set_pos(pos)
		self.set_pos(get_pos())
		animName = "running"

	#if the player is running left
	elif Input.is_action_pressed("run_left"):
		if direction == 1:
			direction = -1
			self.set_flip_h(true)
		#runElapsed for smoother running
		if runElapsed > 0.05:
			runElapsed = 0
			pos.x -= speed.x
			set_pos(pos)
		self.set_pos(get_pos())
		animName = "running"
	else:
		animName = "idle"

	#If the player shot (button mash, not auto)d
	if Input.is_action_pressed("shoot"):
		if tempElapsed > 0.05:
			if shot_fired == 0:
				shot_fired = 1
				var bullet = preload("res://bullet.scn").instance()
				bullet.set_pos(get_node("shoot_from").get_global_pos())
				if direction == -1:
					bullet.speed *= -1
					bullet.set_pos(Vector2(bullet.get_pos().x - 24, bullet.get_pos().y))
				get_node("../..").add_child(bullet)
				set_frame(1)
	elif shot_fired == 1:
		run_loop = 0
		tempElapsed = 0
		shot_fired = 0
		if get_frame() == 1:
			set_frame(0)
	updateAnim(delta)

func updateAnim(delta):
	tempElapsed += delta
	var fps = 10
	var frameDelay = 1.0/fps

	var startsAt
	var endsAt
	if animName == "running":
		startsAt = 2
		endsAt = 6
	elif animName == "idle":
		startsAt = 1
		endsAt = 1
	
	while tempElapsed > frameDelay:
		tempElapsed -= frameDelay
		var frameToGo = get_frame()+1
		if frameToGo > endsAt: frameToGo = startsAt
		set_frame(frameToGo)
