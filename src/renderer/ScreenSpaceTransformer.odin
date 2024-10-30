package renderer

import "../types"
import rl "vendor:raylib"

_3d_to_screen :: proc(input: ^rl.Vector3) -> ^rl.Vector3 {
	input.x = (input.x + 1) * types.BUFFER_WIDTH / 2
	input.y = (-input.y + 1) * types.BUFFER_HEIGHT / 2
	return input
}
