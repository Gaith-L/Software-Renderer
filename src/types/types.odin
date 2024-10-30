package types

import rl "vendor:raylib"

v2 :: rl.Vector2
v3 :: rl.Vector3

BUFFER_WIDTH :: 800
BUFFER_HEIGHT :: 800

t2dPixelBuffer :: [BUFFER_HEIGHT][BUFFER_WIDTH]rl.Color

tPixelBuffer :: struct {
	pixels: ^t2dPixelBuffer,
	width:  int,
	height: int,
}
