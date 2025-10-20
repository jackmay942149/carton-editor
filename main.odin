package main

import ctn "../the-carton"

cube_fbx := #load("./assets/models/cube.fbx")

main :: proc() {
	ctn.init_window(1600, 900, "The Carton", .OpenGL)
	cube_mesh := ctn.register_mesh(cube_fbx)	
	cube_shader := ctn.register_shader("./assets/shaders/default.vert", "./assets/shaders/default.frag")
	ctn.attach_shader_to_material(&cube_mesh.material, cube_shader)

	cube := ctn.Entity {
		position = {0, 0, 0},
		mesh = &cube_mesh,
	}

	cam := ctn.Camera {
		position = {0, 0, -100},
	}

	scene := ctn.Scene {
		entities = {cube},
		camera = cam,
	}

	for !ctn.should_close_window() {
		ctn.update_window(&scene)
	}
	ctn.destroy_window()
}
