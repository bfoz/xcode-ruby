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

	# @!attribute target_type
	#   @return [Symbol]  the {Target}'s type. Either :aggregate or :legacy. Defaults to nil.
	attr_accessor :target_type

	# @!attribute tool_path
	#   @return [String]  the path to an external build tool
	attr_accessor :tool_path

	# @!attribute tool_arguments
	#   @return [String]  the argument string to pass to an external build tool
	attr_accessor :tool_arguments

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

	def to_h
	    {'Name' => name,
	     'TargetType' => (:aggregate == target_type) ? 'Aggregate' : ((:legacy == target_type) ? 'Legacy' : nil),
	     'BuildToolPath' => tool_path,
	     'BuildToolArgsString' => tool_arguments,
	     'SharedSettings' => settings.empty? ? nil : settings,
	     'Configurations' => configurations,
	    }
	end
    end
end
