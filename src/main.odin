package main

import "./renderer"
import t "./types"
import "./shapes"
import "core:fmt"
import "core:math"
import "core:slice"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(t.BUFFER_WIDTH, t.BUFFER_HEIGHT, "Software Renderer")
	rl.SetWindowState({.WINDOW_RESIZABLE, .WINDOW_UNDECORATED})
	rl.SetTargetFPS(0)
	rl.SetWindowMonitor(2)

	buffer := new(t.tPixelBuffer)
	buffer.pixels = {}
	buffer.width = t.BUFFER_WIDTH
	buffer.height = t.BUFFER_HEIGHT

	state := new(t.State)
	state.cube_original = shapes.make_cube(1)
	state.cube = state.cube_original

	image: rl.Image = rl.GenImageColor(t.BUFFER_WIDTH, t.BUFFER_HEIGHT, rl.BLANK)
	image.data = &buffer.pixels
	image.format = rl.PixelFormat.UNCOMPRESSED_R8G8B8A8
	texture: rl.Texture = rl.LoadTextureFromImage(image)
	defer rl.UnloadTexture(texture)

	for !rl.WindowShouldClose() {

		renderer.main_loop(buffer, state)

		rl.UpdateTexture(texture, &buffer.pixels)
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawTexture(texture, 0, 0, rl.WHITE)

		buffer.pixels = {}

		rl.EndDrawing()
		rl.DrawFPS(10,10)
	}
	rl.CloseWindow()
}
