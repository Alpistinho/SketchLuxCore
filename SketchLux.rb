# Name         : SketchLux.rb
# Description  : Sketchup extension for Luxrender
# Authors      : Daniel Moreira Guimarães (Alpistinho)
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
	#main_menu = UI.menu("Plugins").add_submenu("LuxRender")
    
    modelVertices = Hash.new
    modelEntities = activeModel.entities
    face_count = 0
    vertex_count = 0
    plyContent = "ply
    format ascii 1.0
    comment Created by Blender3D 248 - www.blender.org, source file: simple.blend
    element vertex 10
    property float x
    property float y
    property float z
    property uchar red
    property uchar green
    property uchar blue
    element face 4
    property list uchar uint vertex_indices
    end_header"
    modelEntities.each { |entity|
      if entity.is_a? Sketchup::Face
        faceMesh = entity.mesh
        facePoints = faceMesh.points
        facePoints.each {|point|
          plyContent << point.x.to_f.to_s << " " << point.y.to_f.to_s << " " << point.z.to_f.to_s << " 255 255 255\n"
        }
        
        face_count = face_count + 1
        faceVertices = entity.vertices
        faceVertices.each { |vertex|
          modelVertices[vertex.entityID] = vertex
        }
      end
    }
    puts plyContent
    File.open("C:\\Users\\danie\\Documents\\sketchLux\\test.ply", 'w') {|f| f.write(plyContent) }
    UI.messagebox("There are " + face_count.to_s + " faces selected and " + modelVertices.length.to_s + " vertices")
      
end
