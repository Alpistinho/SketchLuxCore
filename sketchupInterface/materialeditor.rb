require_relative 'editor.rb'

module SketchLux
	
	class MaterialEditor < Editor

		def initialize(activeModel, materialStorages)

			super(activeModel)

			@materialStorages = materialStorages

		end

	end

end