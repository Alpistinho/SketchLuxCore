
require texture

class ConstFloat3 < Texture

	def initialize(value = nil)

		if value
			@value = value
		else #has not been defined
			@value = Vector[1.0,1.0,1.0]
		end

	end

	def textualDescription()

		textureDefinition = ''
		textureDefinition = textureDefinition + 'scene.textures.' + @name + '.type = constfloat3 \n'

		value = ''
		@value.each { |element|
			value = value + element.to_s + ' '
		}

		textureDefinition = textureDefinition + 'scene.textures.' + @name + '.value = ' + value + '\n'

	end

end
