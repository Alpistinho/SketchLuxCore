require shape

class StrandsShape < Shape

	def initialize(shapeName, strandsPath, tessellationMethod = 'ribbon', tessellationOptions = nil)

		super()

		@type = 'strands'
		@name = shapeName
		@strandsPath = strandsPath
		@tessellationMethod = tessellationMethod
		@tessellationOptions = tessellationOptions #here the options should be a Hash object

	end

	def textualDescription()

		shapeDefinition = ''
		shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'type = ' + @type + '\n'
		shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'file = ' + @strandsPath + '\n'

		if !(tessellationOptions) #default option
			
			#not sure if it is better to write or not the option in the file
			# shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.type = ribbon\n'
			# shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.usecameraposition = 1\n'
			
			return shapeDefinition

		end

		shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.type = ' + @type.to_s + '\n'

		if @type == "ribbon"
			
			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.usecameraposition = ' + @useCameraPosition.to_s + '\n'

		elsif @type == 'ribbonadaptive'

			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.adaptative.maxdepth = ' + @adaptativeMaxDepth.to_s + '\n'
			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.adaptative.error  = ' + @adaptativeError .to_s + '\n'

		elsif @type == 'solid'
			
			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.solid.sidecount = ' + @solidSideCount.to_s + '\n'

		elsif @type == 'solidadaptive'

			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.solidadaptive.sidecount = ' + @solidAdaptiveSideCount.to_s + '\n'
			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.solidadaptive.maxdepth = ' + @solidAdaptiveMaxdepth.to_s + '\n'
			shapeDefinition = shapeDefinition + 'scene.shapes.' + @name + 'tessellation.solidadaptive.error = ' + @solidAdaptiveError.to_s + '\n'

		end


			
		return shapeDefinition

	end


end