class_name Level extends Node2D

@export var nav_tiles: TileMapLayer = null
@export var enemies_per_wave: int = 3
@export var potion_difficulty: int = 0
@export var waves_per_difficulty_increase: int = 5
@export var start_difficulty: int = 0
@export var difficulty_variance: float = 0.5