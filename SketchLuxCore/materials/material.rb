module SketchLux

	class Material
		
		#This Hash holds the parameters shared between all materials
		#the values in the array should be how these parameters are defined in LuxCore
		#these values are used to produce the accessors, converting the periods characters into "Java style"
		@@commonParameters = ["transparency", "id", "bumptex", "normaltex", "emission", "emission.gain", 
							  "emission.power", "emission.efficency", "emission.samples", "emission.mapfile",
							  "emission.mapwidth", "emission.mapheight", "emission.gamma", "emission.iesfile", 
							  "emission.flipz", "volume.interior", "volume.exterior", "visibilityindirectdiffuse.enable",
							  "visibilityindirectglossy.enable", "visibilityindirectspecular.enable","bumpsampledistance", 
							  "shadowcatcher.enable"]

		#which parameters are accessible to each type
		#the values in the array should be how these parameters are defined in LuxCore
		#these values are used to produce the accessors, converting the periods characters into "Java style"
		@@typeParameters = Hash.new
		
		@@typeParameters["archglass"] = ['kr', 'kt', 'interiorior', 'exteriorior']
		@@typeParameters["carpaint"] = ['preset', 'ka', 'd', 'kd', 'ks1','ks2','ks3', 'r1', 'r2', 'r3', 'm1', 'm2', 'm3']
		@@typeParameters["cloth"] = ["preset", "weft_kd", "weft_ks", "warp_kd", "warp_ks" , "repeat_u", ".repeat_v"]
		@@typeParameters["glass"] = ['kr', 'kt', 'interiorior', 'exteriorior']
		@@typeParameters["glossy2"] = ["kd", "ks", "uroughness", "vroughness", "ka", "d", "index", "multibounce"]
		@@typeParameters["matte"] = ["kd"]
		@@typeParameters["mattetranslucent"] = ['kd' , 'kt']
		@@typeParameters["metal2"] = ["fresnel", "uroughness", "vroughness", "preset", "n", "k"]
		@@typeParameters["mirror"] = ['kr']
		@@typeParameters["mix"] = ["material1", "material2", "amount"]
		@@typeParameters["null"] = []
		@@typeParameters["roughglass"] = ['kr', 'kt', 'interiorior', 'exteriorior', 'uroughness', 'vroughness']
		@@typeParameters["roughmatte"] = ['kd', 'sigma']
		@@typeParameters["velvet"] = ["kd", "p1", "p2", "p3", "thickness"]

		def initialize(type, name)
			
			@type = type
			@name = name

			#holds all properties for all materials
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
			definitionLines << 'scene.materials.' + @name + '.type = ' + @type
			
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
				return 'scene.materials.' + @name + '.' + parameterName  + ' = ' + parameterString
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