extends Node2D


export var size := Vector2(800, 600)

var template: PackedScene = preload("res://assets/demos/boids/boid_agent.tscn")
var agent_type = preload("res://assets/demos/boids/boid_agent.gd")

onready var imgui:ImGui = $imgui

var agents: Array = []

func _process(delta):
	imgui.begin("arst")
	if imgui.button("add agent"):
		add_agent()
		
	for agent in agents:
		imgui.text(agent.name)
	
	imgui.end()

func add_agent():
	var new_agent: Node2D = template.instance()
	assert(new_agent is agent_type)
	new_agent.name = "agent_%d" % len(agents)
	add_child(new_agent)
	agents.append(new_agent)
	
	var pos = Vector2(randf(), randf()) * size
	new_agent.position = pos
	
