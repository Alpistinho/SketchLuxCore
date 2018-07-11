module SketchLuxCore

	class Pair
		attr_accessor :one, :two
		def initialize(one, two)
			@one = one
			@two = two
		end
	end

	def SketchLuxCore.exportGeometry()
		#get the model currently focused by the user
		activeModel = Sketchup.active_model
		
		modelVertices = Hash.new
		modelEntities = activeModel.entities
		faceCount = 0
		vertexCount = 0
		plyVertices = ""
		plyFaces = "" 
		
		modelEntities.each { |entity|
			if entity.is_a? Sketchup::Face
				vertices = entity.vertices
				plyFaces << vertices.length.to_s << " "
				vertices.each { |vertex|
					if !modelVertices[vertex.entityID]
						modelVertices[vertex.entityID] = Pair.new(vertex, vertexCount)
						vertexCount = vertexCount + 1
						plyVertices << vertex.position.x.to_f.to_s << " " << vertex.position.y.to_f.to_s << " " << vertex.position.z.to_f.to_s <<  " 255 255 255\n"
					end
					plyFaces << modelVertices[vertex.entityID].two.to_s << " "
					
				}
				faceCount = faceCount + 1
				plyFaces << "\n"
			end
		}

		plyHeader = [
			"ply",
			"format ascii 1.0",
			"element vertex #{vertexCount}",
			"property float x",
			"property float y",
			"property float z",
			"property uchar red",
			"property uchar green",
			"property uchar blue",
			"element face #{faceCount}",
			"property list uchar uint vertex_indices",
			"end_header"].join("\n") + "\n"	
	
		plyContent = plyHeader << plyVertices << plyFaces
		File.open("C:\\Users\\danie\\Documents\\sketchLux\\test.ply", 'w') {|f| f.write(plyContent) }
		UI.messagebox("There are " + faceCount.to_s + " faces selected and " + modelVertices.length.to_s + " vertices")
	end
end