package renderer

import "../types"
import "core:fmt"
import rl "vendor:raylib"

draw_pixel :: proc(buffer: ^types.tPixelBuffer, x, y: int) {
	if x >= 0 && x < buffer.width && y >= 0 && y < buffer.height {
		buffer.pixels[y][x] = rl.RED
	}
}

draw_line :: proc(buffer: ^types.tPixelBuffer, x0, y0, x1, y1: int) {
	dx := abs(x1 - x0)
	dy := abs(y1 - y0)

	sx := x1 > x0 ? 1 : -1
	sy := y1 > y0 ? 1 : -1

	err := dx - dy

	x, y := x0, y0
	for {
		draw_pixel(buffer, x, y)
		if x == x1 && y == y1 do break

		e2 := 2 * err
		if e2 > -dy {
			err -= dy
			x += sx
		}
		if e2 < dx {
			err += dx
			y += sy
		}
	}
}

draw_square :: proc(buffer: ^types.tPixelBuffer, x, y, size: int) {
	start_x := x - size / 2
	start_y := y - size / 2

	for dy := 0; dy < size; dy += 1 {
		for dx := 0; dx < size; dx += 1 {
			px := start_x + dx
			py := start_y + dy
			draw_pixel(buffer, px, py)
		}
	}
}

render :: proc(buffer: ^types.tPixelBuffer) {
    guh_3d : rl.Vector3 = {.99,-0.99,0.0}
    guh_screen := _3d_to_screen(&guh_3d)
	draw_pixel(buffer, int(guh_screen.x), int(guh_screen.y))
}
