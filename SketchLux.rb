# Name         : SketchLux.rb
# Description  : Sketchup extension for Luxrender
# Authors      : Daniel Moreira Guimarães (Alpistinho)
# 				 Abel Groenewolt
#
# 				Inspired on the previous Luxrender exporter, su2lux, by:
#  					Abel Groenewolt
#               	Alexander Smirnov (aka Exvion)  e-mail: exvion@gmail.com
#               	Mimmo Briganti (aka mimhotep)

require 'sketchup.rb'
#TODO implement fallback for Ruby 1.8 (used by Sketchup 8)
require_relative 'storage/materialstorage.rb'

require_relative 'sketchupInterface/sketchLuxToolbar.rb'
require_relative 'sketchupInterface/sketchLuxMainMenu.rb'
require_relative 'sketchupInterface/materialeditor.rb'
require_relative 'sketchupInterface/enginesettingseditor.rb'


module SketchLux

	#These hashes should be used to store the Storage's objects that hold the Luxrender scene objects.
	#Each Sketchup active_model should have one storage of each type linked to it
	#The key should be the active_model names
	materialStorages = Hash.new
	textureStorages = Hash.new
	shapeStorages = Hash.new
	volumeStorages = Hash.new
	lightStorages = Hash.new

	#Hash holding all Storages of each type
	storages = {"material" => materialStorages, "texture" => textureStorages, "shape" => shapeStorages, "volume" => volumeStorages, "light" => volumeStorages}

	#Used to store the observers
	#keys should be the active_model names
	observers = Hash.new


	#These hashes should be used to store the settings.
	#Each Sketchup active_model should have one setting of each type linked to it
	#The key should be the active_model names
	samplerSettings = Hash.new
	engineSettings = Hash.new
	cameraSettings = Hash.new
	filterSettings = Hash.new
	filmSettings = Hash.new

	#Hash holding all settings
	settings = {"engine" => engineSettings, "sampler" => samplerSettings, "camera" => cameraSettings, "filter" => filmSettings, "film" => filmSettings}

	#get the model currently focused by the user
	activeModel = Sketchup.active_model

	#creates the editors that control the user interface
	materialEditor = MaterialEditor.new(activeModel, materialStorages)
	engineSettingsEditor = EngineSettingsEditor.new(activeModel, engineSettings)

	#creates the SketchLux toolbar using the editor sent in the parameters
	toolbar = SketchLux::createToolbar(materialEditor, engineSettingsEditor)
	mainMenu = SketchLux::mainMenu()

end
