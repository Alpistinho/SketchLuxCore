	# Create an entry in the Extension list that loads a script called
	# core.rb.
	require 'sketchup.rb'
	require 'extensions.rb'


	sketchLux_extension = SketchupExtension.new('sketchLux', 'sketchLux/SketchLux.rb')
	sketchLux_extension.version = 'development'
	sketchLux_extension.description = 'Exporter to LuxRender (Luxcore)'
	sketchLux_extension.copyright = 'GPL2, free software'
	sketchLux_extension.creator = 'the LuxCoreRender team'
	Sketchup.register_extension(sketchLux_extension, true)