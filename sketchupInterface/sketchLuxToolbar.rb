module SketchLux

	def self.createToolbar(materialEditor, engineSettingsEditor)

		sketchLuxToolbar = UI::Toolbar.new("SketchLux")

		cmd_render = UI::Command.new("Render"){}
		cmd_render.small_icon = "icons\\su2lux_render.png"
		cmd_render.large_icon = "icons\\su2lux_render.png"
		cmd_render.tooltip = "Export and Render with LuxRender"
		cmd_render.menu_text = "Render"
		cmd_render.status_bar_text = "Export and Render with LuxRender"

		sketchLuxToolbar.add_item(cmd_render)

		sketchLuxToolbar.show

		return sketchLuxToolbar

	end

end