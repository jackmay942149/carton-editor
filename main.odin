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

	entities := make([]ctn.Entity, 1)
	meshes := make([]ctn.Mesh, 1)

	args := os.args
	if len(args) > 1 {
		project_data, ok := os.read_entire_file_from_filename(args[1])		
		assert(ok)
		project_json, err := json.parse(project_data)
		if err != nil {
			log.fatal(err)
			assert(false)
		}
		scene_path := project_json.(json.Object)["scene"].(json.String)

		scene_data: []u8
		scene_data, ok = os.read_entire_file_from_filename(scene_path)
		assert(ok)
		scene_json: json.Value
		scene_json, err = json.parse(scene_data)
		if err != nil {
			log.fatal(err)
			assert(false)
		}
		entity_json := scene_json.(json.Object)["entities"].(json.Array)[0].(json.Object)
		meshes[0] = ctn.register_mesh(entity_json["mesh"].(json.Object)["path"].(json.String))
		shader := ctn.register_shader(entity_json["mesh"].(json.Object)["material"].(json.Object)["vert"].(json.String), entity_json["mesh"].(json.Object)["material"].(json.Object)["frag"].(json.String))
		ctn.attach_shader_to_material(&meshes[0].material, shader)
		entities[0].mesh = &meshes[0]
	} else {
		assert(false)		
	}

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
