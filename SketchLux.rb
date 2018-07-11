# Name         : SketchLux.rb
# Description  : Sketchup extension for Luxrender
# Authors      : Daniel Moreira Guimarães (Alpistinho)
#
# 				Inspired on the previous Luxrender exporter, su2lux, by:
#  					Abel Groenewolt
#               	Alexander Smirnov (aka Exvion)  e-mail: exvion@gmail.com
#               	Mimmo Briganti (aka mimhotep)

require 'sketchup.rb'
require 'sketchLux/exportGeometry.rb'

menu = UI.menu('Plugins')
menu.add_item("Test") { puts SketchLuxCore.exportGeometry() } 