require_relative 'editor.rb'

module SketchLux
	
	class EngineSettingsEditor < Editor

		def initialize(activeModel, engineSettings)

			super(activeModel)

			@engineSettings = engineSettings

		end

	end

end