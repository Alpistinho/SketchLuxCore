require_relative 'storage.rb'
require_relative '../materials/material.rb'


module SketchLux

	class MaterialStorage < Storage
		
		def addNewMaterial(materialType, name)

			#if the material does not exist
			if !@storedObjects[name]
			
				newMaterial = Material.new(materialType, name)
				@storedObjects[name] = newMaterial
			
				return newMaterial
			
			end	
			
			#name already in use
			return nil		

		end

		def removeMaterial(name)

			@storedObjects[name] = nil
			
		end


	end

end