extends Control

@onready var hour: Label = $Hour
@onready var minutes: Label = $Minutes
@onready var daymonthyear: Label = $DayMonthYear
@onready var money: Label = $Money


func _ready():
	TimeManager.time_tick.connect(on_time_tick)
	

func on_time_tick():
	hour.text = "%02d" % TimeManager.hour
	minutes.text = "%02d" % TimeManager.minute
	daymonthyear.text = "Day " + str(TimeManager.day) + ". Year " + str(TimeManager.year)
#	year_container.text = "Year " + str(TimeManager.year)
#	day_container.text = "Day " + str(TimeManager.day)
#	time_container.text = "Time: " + TimeManager.current_time
