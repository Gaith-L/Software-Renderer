package main

import "./renderer"
import "./types"
import "core:fmt"
import "core:math"
import "core:slice"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(types.BUFFER_WIDTH, types.BUFFER_HEIGHT, "Software Renderer")
	rl.SetWindowState({.WINDOW_RESIZABLE, .WINDOW_UNDECORATED})
	rl.SetTargetFPS(0)

	buffer := new(types.tPixelBuffer)
	buffer.pixels = {}
	buffer.width = types.BUFFER_WIDTH
	buffer.height = types.BUFFER_HEIGHT

	image: rl.Image = rl.GenImageColor(types.BUFFER_WIDTH, types.BUFFER_HEIGHT, rl.BLANK)
	image.data = &buffer.pixels
	image.format = rl.PixelFormat.UNCOMPRESSED_R8G8B8A8
	texture: rl.Texture = rl.LoadTextureFromImage(image)
	defer rl.UnloadTexture(texture)

	for !rl.WindowShouldClose() {
		renderer.render(buffer)
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
