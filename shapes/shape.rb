module SketchLux

	class Shape
		
		#This Hash holds the parameters shared between all cameras
		#the values in the array should be how these parameters are defined in LuxCore
		#these values are used to produce the accessors, converting the periods characters into "Java style"
		@@commonParameters = ["lookat.orig", "lookat.target", "up", "fieldofview", "screenwindow", "cliphither", "clipyon", "shutteropen", "shutterclose",
							  "clippingplane.enable", "clippingplane.center", "clippingplane.normal", "lensradius", "focaldistance", "autofocus.enable"]

		#which parameters are accessible to each type
		#the values in the array should be how these parameters are defined in LuxCore
		#these values are used to produce the accessors, converting the periods characters into "Java style"
		@@typeParameters = Hash.new
		
		@@typeParameters["inlinedmesh"] = ['vertices', 'faces']
		@@typeParameters["mesh"] = ['ply']
		@@typeParameters["pointness"] = ['source']
		@@typeParameters["strands"] = [] #TODO

		def initialize(type, name)
			
			@type = type
			@name = name

			#holds all properties for all cameras
			#storing nil means not the export this definition and let Luxcore use the default
			@properties = Hash.new

			produceAccessors()

			#produces the accessors for the common parameters 
			@@commonParameters.each { |parameter|

				key = convertPeriodToUppercase(parameter)

				self.class.send(:define_method,key) { 
					@properties[key] 
				}

				setter = key + '='
				self.class.send :define_method, setter do |value| 
					@properties[key] = value
				end
			}


		end

		#procuce accessors from the values stored in the @@typeParameters Hash
		def produceAccessors()


			@@typeParameters[@type].each { |parameter|

				key = convertPeriodToUppercase(parameter)

				self.class.send(:define_method,key) { 
					@properties[key] 
				}

				setter = key + '='
				self.class.send :define_method, setter do |value| 
					@properties[key] = value
				end

			}

		end

		#remove all accessors defined from the @@typeParameters Hash
		def removeAccessors()

			@@typeParameters[@type].each { |parameter|

				key = convertPeriodToUppercase(parameter)
				self.class.send(:undef_method,key)

				setter = key + '='
				self.class.send :undef_method, setter

			}
		end

		#change the material type, changing the avaliable accessors
		def changeType(newType)
			#remove accessors for old type
			removeAccessors()
			@type = newType

			#produce accessors for the newly set type
			produceAccessors()
		end
	 	
		#return the complete Material definition
		def definition()
		
			definitionLines ||= []
			definitionLines << 'scene.shapes.' + @name + '.type = ' + @type
			
			@@commonParameters.each { |parameter|

				parameter = convertPeriodToUppercase(parameter)

				parameterString = parameterDefinition(parameter)

				if parameterString
					definitionLines << parameterString
				end
			}

			@@typeParameters[@type].each {|parameter|
				
				parameter = convertPeriodToUppercase(parameter)

				parameterString =  parameterDefinition(parameter)
				if parameterString
					definitionLines << parameterString
				end
			}

			return definitionLines
		
		end

		#produces one line of the description, referring to parameter received in the parameterName argument
		def parameterDefinition(parameterName)

			parameterString = stringFromParameter(@properties[parameterName])
			if parameterString
				return 'scene.shapes.' + @name + '.' parameterName  + ' = ' + parameterString
			end

			#parameter not set
			return nil

		end

		#convert the different types of parameters stored to their string representation
		def stringFromParameter(parameterValue)

			if parameterValue.is_a?(Array)
				parameterString = ''
				parameterValue.each_with_index { |value, index|

					if parameterValue.size > 1
						if index != 0
							parameterString = parameterString + " " + value.to_s
						else
							parameterString = value.to_s
						end
					else
						parameterString = value.to_s
					end
				}

				return parameterString
			end

			#if parameterValue is a Boolean
			if !!parameterValue == parameterValue
				return parameterValue.to_s
			end

			if parameterValue.is_a?(Numeric)
				return parameterValue.to_s
			end

			if parameterValue.is_a?(String)
				return parameterValue
			end

			return nil #parameter has not been set

		end

		#not a very inspired name...
		#converts an string separated by periods characters to the so-called "Java style"
		#emission.gain becomes emissionGain
		def convertPeriodToUppercase(input)
			
			input = input.split('.')
			output = ''
			input.each_with_index { |value, index|
				if input.size > 1
					if index != 0
						output = output + input[index].capitalize
					else
						output = input[index]
					end
				else
					output = output + input[index]
				end
			}

			return output

		end

	end

end