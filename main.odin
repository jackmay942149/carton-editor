package main

import ctn "../the-carton"
import editor "scripts"

cube_fbx := #load("./assets/models/cube.fbx")

main :: proc() {
	ctn.init_window(1600, 900, "The Carton", .OpenGL)

	cube_mesh := ctn.register_mesh(cube_fbx)	

	cube_shader := ctn.register_shader("./assets/shaders/default.vert", "./assets/shaders/default.frag")

	ctn.attach_shader_to_material(&cube_mesh.material, cube_shader)

	ui_box := ctn.box_create("Heirarchy", {91.0/255.0, 156.0/255.0, 209.0/255.0, 1}, {-.8, 0}, {0.4, 2})

	ui := ctn.UI {
		components = {
			ctn.UI_Component {
				elements = {ui_box}
			}
		}
	}

	cube := ctn.Entity {
		position = {0, 0, 0},
		mesh = &cube_mesh,
	}

	cam := ctn.Camera {
		position = {0, 0, -100},
		update = editor.camera_update
	}

	scene := ctn.Scene {
		entities = {cube},
		camera = cam,
		ui = ui,
	}

	for !ctn.should_close_window() {
		ctn.update_window(&scene)
	}
	ctn.destroy_window()
}
