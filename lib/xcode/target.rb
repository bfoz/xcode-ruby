module Xcode
    class Target
	# @!attribute name
	#   @return [String]
	attr_accessor :name

	# @!attribute [r] configurations
	#   @return [Hash]  Build configurations
	attr_reader :configurations

	# @!attribute [r] settings
	#   @return [Hash]  Settings shared by all of the Project's configurations
	attr_reader :settings

	def initialize(name=nil)
	    @name = name
	    @configurations = Hash.new {|h,k| h[k] = {} }
	    @settings = {}
	end

	# Set a shared setting
	# @param args [Hash]
	def set(*args)
	    @settings.merge! *args
	end

	def to_hash
	    {'Name' => name,
	     'SharedSettings' => settings,
	     'Configurations' => configurations,
	    }
	end
    end
end
