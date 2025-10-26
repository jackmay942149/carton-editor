package main

import ctn "../the-carton"
import editor "scripts"
import log "core:log"
import os "core:os"
import json "core:encoding/json"

cube_fbx := #load("./assets/models/cube.fbx")

main :: proc() {
	context.logger = log.create_console_logger()

	ctn.init_window(1600, 900, "The Carton", .OpenGL)

	ui_box := ctn.box_create("Heirarchy", {91.0/255.0, 156.0/255.0, 209.0/255.0, 1}, {-.8, 0}, {0.4, 2})
	ui := ctn.UI {
		components = {
			ctn.UI_Component {
				elements = {ui_box}
			}
		}
	}

	cam := ctn.Camera {
		position = {0, 0, -100},
		update = editor.camera_update
	}

	entities: []ctn.Entity
	meshes: []ctn.Mesh

	args := os.args
	if len(args) > 1 {
		project := ctn.load_project_file(args[1])
		scene_description := ctn.load_scene_file(project.scene)

		entities = make([]ctn.Entity, len(scene_description.entities))
		meshes = make([]ctn.Mesh, len(scene_description.entities))

		for i in 0..<len(scene_description.entities) {
			meshes[i] = ctn.register_mesh(scene_description.entities[i].mesh.path)

			shader := ctn.register_shader(scene_description.entities[i].mesh.material.vert, scene_description.entities[i].mesh.material.frag)
			ctn.attach_shader_to_material(&meshes[i].material, shader)
			entities[i].mesh = &meshes[i]
			entities[i].position = scene_description.entities[i].position
			entities[i].scale = scene_description.entities[i].scale
			entities[i].id = i
		}
	} else {
		assert(false)		
	}

	editor.light_components = make([]editor.Light_Component, len(entities))
	editor.light_components[1].colour = {1.0, 0.0, 0.0}
	editor.light_components[2].colour = {0.0, 1.0, 0.0}
	editor.light_components[3].colour = {0.0, 0.0, 1.0}
	editor.light_components[4].colour = {1.0, 1.0, 1.0}
	entities[1].update = editor.light_update
	entities[2].update = editor.light_update
	entities[3].update = editor.light_update
	entities[4].update = editor.light_update

	scene := ctn.Scene {
		entities = entities,
		camera = cam,
		ui = ui,
	}

	for !ctn.should_close_window() {
		ctn.update_window(&scene)
	}
	ctn.destroy_window()
}
