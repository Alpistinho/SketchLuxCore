module SketchLux

	class Engine
		
		#This Hash holds the parameters shared between all engines
		#the values in the array should be how these parameters are defined in LuxCore
		#these values are used to produce the accessors, converting the periods characters into "Java style"
		@@commonParameters = ["renderengine.type", "renderengine.seed"]

		#which parameters are accessible to each type
		#the values in the array should be how these parameters are defined in LuxCore
		#these values are used to produce the accessors, converting the periods characters into "Java style"
		@@typeParameters = Hash.new
		
		@@typeParameters["PATHCPU"] = ['path.maxdepth', 'path.russianroulette.depth', 'path.russianroulette.cap', 'path.clamping.variance.maxvalue',
									   'path.clamping.pdf.value', 'path.fastpixelfilter.enable', 'native.threads.count']

		@@typeParameters["BIASPATHCPU"] = ['biaspath.pathdepth.total', 'biaspath.pathdepth.diffuse', 'biaspath.pathdepth.glossy', 'biaspath.pathdepth.specular',
										   'biaspath.sampling.aa.size','biaspath.sampling.diffuse.size','biaspath.sampling.glossy.size', 'biaspath.sampling.specular.size',
										   'biaspath.sampling.directlight.size', 'biaspath.lights.lowthreshold', 'biaspath.lights.nearstart', 'biaspath.lights.firstvertexsamples',
										   'biaspath.clamping.variance.maxvalue', 'biaspath.clamping.pdf.value', 'tile.size', 'tile.size.x', 'tile.size.y', 'tile.multipass.enable',
										   'tile.multipass.convergencetest.threshold', 'tile.multipass.convergencetest.threshold256', 'tile.multipass.convergencetest.threshold.reduction',
										   'tile.multipass.convergencetest.warmup.count', 'native.threads.count']

		@@typeParameters["BIDIRCPU"] = ["path.maxdepth", "light.maxdepth", "path.russianroulette.depth", "path.russianroulette.cap", 'native.threads.count']

		@@typeParameters["PATHOCL"] = ['path.maxdepth', 'path.russianroulette.depth', 'path.russianroulette.cap', 'path.clamping.variance.maxvalue',
									   'path.clamping.pdf.value', 'path.fastpixelfilter.enable', 'pathocl.pixelatomics.enable', 'opencl.task.count',
									   'opencl.platform.index', 'opencl.cpu.use', 'opencl.gpu.use', 'opencl.cpu.workgroup.size' ,'opencl.gpu.workgroup.size' ,
									   'opencl.devices.select']

		@@typeParameters["RTPATHOCL"] = ['path.maxdepth', 'path.russianroulette.depth', 'path.russianroulette.cap', 'path.clamping.variance.maxvalue',
										'path.clamping.pdf.value', 'path.fastpixelfilter.enable', 'pathocl.pixelatomics.enable', 'opencl.task.count',
										'opencl.platform.index', 'opencl.cpu.use', 'opencl.gpu.use', 'opencl.cpu.workgroup.size' ,'opencl.gpu.workgroup.size' ,
										'opencl.devices.select', 'rtpath.miniterations']

		@@typeParameters["BIASPATHOCL"] = ['biaspath.pathdepth.total', 'biaspath.pathdepth.diffuse', 'biaspath.pathdepth.glossy', 'biaspath.pathdepth.specular',
										   'biaspath.sampling.aa.size','biaspath.sampling.diffuse.size','biaspath.sampling.glossy.size', 'biaspath.sampling.specular.size',
										   'biaspath.sampling.directlight.size', 'biaspath.lights.lowthreshold', 'biaspath.lights.nearstart', 'biaspath.lights.firstvertexsamples',
										   'biaspath.clamping.variance.maxvalue', 'biaspath.clamping.pdf.value', 'tile.size', 'tile.size.x', 'tile.size.y', 'tile.multipass.enable',
										   'tile.multipass.convergencetest.threshold', 'tile.multipass.convergencetest.threshold256', 'tile.multipass.convergencetest.threshold.reduction',
										   'tile.multipass.convergencetest.warmup.count', 'biaspathocl.devices.maxtiles']

		@@typeParameters["RTBIASPATHOCL"] = ['biaspath.pathdepth.total', 'biaspath.pathdepth.diffuse', 'biaspath.pathdepth.glossy', 'biaspath.pathdepth.specular',
											'biaspath.sampling.aa.size','biaspath.sampling.diffuse.size','biaspath.sampling.glossy.size', 'biaspath.sampling.specular.size',
											'biaspath.sampling.directlight.size', 'biaspath.lights.lowthreshold', 'biaspath.lights.nearstart', 'biaspath.lights.firstvertexsamples',
											'biaspath.clamping.variance.maxvalue', 'biaspath.clamping.pdf.value', 'tile.size', 'tile.size.x', 'tile.size.y', 'tile.multipass.enable',
											'tile.multipass.convergencetest.threshold', 'tile.multipass.convergencetest.threshold256', 'tile.multipass.convergencetest.threshold.reduction',
											'tile.multipass.convergencetest.warmup.count', 'biaspathocl.devices.maxtiles', 'tpath.resolutionreduction.preview', 'rtpath.resolutionreduction.preview.step',
											'rtpath.resolutionreduction.preview.dlonly.enable', 'rtpath.resolutionreduction', 'rtpath.resolutionreduction.longrun', 'rtpath.resolutionreduction.longrun.step']
		@@typeParameters["FILESAVER"] = []
		@@typeParameters["BIDIRVMCPU"] = []
		@@typeParameters["LIGHTCPU"] = []

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
			definitionLines << 'renderengine.type = '+ @type
			
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
				return @@typeParameters[@type] + ' = ' + parameterString
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