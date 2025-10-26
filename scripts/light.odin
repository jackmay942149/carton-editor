package scripts

import ctn "../../the-carton"

light_components: []Light_Component
Light_Component :: struct {
 colour: [3]f32,
}

light_update :: proc(this: ^ctn.Entity) {
 ctn.opengl_set_uniform_vec3("uni_light_colour", light_components[this.id].colour, this.mesh.material.shader)
}
