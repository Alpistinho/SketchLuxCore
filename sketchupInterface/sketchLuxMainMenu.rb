module SketchLux

	def self.mainMenu

		sketchLuxMainMenu = UI.menu("Plugins").add_submenu("SketchLux")
		sketchLuxMainMenu.add_item("Render") {}

		return sketchLuxMainMenu

	end

end