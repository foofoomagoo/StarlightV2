extends Node

signal time_tick
signal day_tick

var current_time
var minute
var hour
var day: int
var year
var global_timer: Timer


func _ready():
	year = 1
	day = 1
	minute = 0
	hour = 8
	current_time = "%02d:%02d" % [hour, minute]
	global_timer = Timer.new()
	global_timer.set_wait_time(1)
	global_timer.timeout.connect(on_timer_timeout)
	add_child(global_timer)
	global_timer.start()	

func on_timer_timeout():
	minute += 10
	if minute >= 60:
		minute = 0
		hour += 1
		if hour >= 24:
			hour = 0
			day += 1
			end_day()
#			day_tick.emit()
#			if day >= 30:
#				day = 1
#				year += 1
	current_time = "%02d:%02d" % [hour, minute]
	
	time_tick.emit()
	global_timer.start()


func end_day():
#	State.can_move = false
	if day >= 30:
		day = 1
		year += 1
#	Globals.day_ends()
#	day_tick.emit()


func sleep() -> void:
	hour = 8
	day += 1
	if day >= 30:
		day = 1
		year += 1
		
#	CropManager.on_day_tick()
	time_tick.emit()
