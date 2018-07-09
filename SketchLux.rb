# Name         : SketchLux.rb
# Description  : Sketchup extension for Luxrender
# Authors      : Daniel Moreira Guimarães (Alpistinho)
# 				 Abel Groenewolt
#
# 				Inspired on the previous Luxrender exporter, su2lux, by:
#  					Abel Groenewolt
#               	Alexander Smirnov (aka Exvion)  e-mail: exvion@gmail.com
#               	Mimmo Briganti (aka mimhotep)

require 'sketchup.rb'

module SketchLuxCore

	#get the model currently focused by the user
	activeModel = Sketchup.active_model
    
	#creates the SketchLux toolbar using the editor sent in the parameters
	main_menu = UI.menu("Plugins").add_submenu("LuxRender")
    
    modelEntities = activeModel.entities
    face_count = 0
    modelEntities.each { |entity|
      if entity.is_a? Sketchup::Face
        faceMesh = entity.mesh
        facePoints = faceMesh.points
        puts facePoints
        face_count = face_count + 1
      end
    }

    UI.messagebox("There are " + face_count.to_s + " faces selected.")
    
end
