package scripts

import ctn "../../the-carton"

camera_update :: proc(this: ^ctn.Camera) {
	if ctn.is_key_down(.LEFT_ALT) {
		if ctn.is_key_down(.W) {
			this.look_at_position.z += 0.01
		}
		if ctn.is_key_down(.S) {
			this.look_at_position.z -= 0.01
		}
		if ctn.is_key_down(.A) {
			this.look_at_position.x += 0.01
		}
		if ctn.is_key_down(.D) {
			this.look_at_position.x -= 0.01
		}
	}
}
