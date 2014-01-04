module Xcode
    class Template
	class Option
	    class Value
		# @!attribute name
		#   @return [String]  the name to show in the popup menu
		attr_accessor :name

		# @!attribute [r] settings
		#   @return [Hash]  Settings shared by all of the Project's configurations
		attr_reader :settings

		def initialize(name)
		    @name = name
		    @settings = {}
		end

		def to_h
		    settings.empty? ? {} : {'Project' => { 'SharedSettings' => settings}}
		end

		# Set variables that are shared by all of the project's configurations
		# @param args [Hash]
		def set(*args)
		    @settings.merge! *args
		end
	    end
	end
    end
end
