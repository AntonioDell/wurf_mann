extends Node2D
class_name Visualizer

@onready var line: Line2D = $Line2D

func add_point(position: Vector2):
	line.add_point(position)

func reset():
	line.clear_points()
