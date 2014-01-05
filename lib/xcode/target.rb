module Xcode
    class Target
	# @!attribute name
	#   @return [String]
	attr_accessor :name

	# @!attribute [r] build_phases
	#   @return [Array] Build Phases
	attr_reader :build_phases

	# @!attribute [r] configurations
	#   @return [Hash]  Build configurations
	attr_reader :configurations

	# @!attribute product_type
	#   @return [Symbol]  The type of the product built by the target (:application, :bundle, :framework, :kernel_extension, :dynamic_library, :static_library, :tool)
	attr_accessor :product_type

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
	    @build_phases = []
	    @configurations = Hash.new {|h,k| h[k] = {} }
	    @settings = {}
	end

	# Set a shared setting
	# @param args [Hash]
	def set(*args)
	    @settings.merge! *args
	end

	def push(arg)
	    case arg
		when Template::BuildPhase
		    @build_phases.push arg
	    end
	end

	def to_h
	    {'Name' => name,
	     'TargetType' => (:aggregate == target_type) ? 'Aggregate' : ((:legacy == target_type) ? 'Legacy' : nil),
	     'BuildPhases' => build_phases.empty? ? nil : build_phases.map {|a| a.to_h},
	     'BuildToolPath' => tool_path,
	     'BuildToolArgsString' => tool_arguments,
	     'ProductType'  => product_type_identifier,
	     'SharedSettings' => settings.empty? ? nil : settings,
	     'Configurations' => configurations,
	    }
	end

private
	def product_type_identifier
	    case product_type
		when :application	then 'com.apple.product-type.application'
		when :bundle		then 'com.apple.product-type.bundle'
		when :framework		then 'com.apple.product-type.framework'
		when :kernel_extension	then 'com.apple.product-type.kernel-extension'
		when :dynamic_library	then 'com.apple.product-type.library.dynamic'
		when :static_library	then 'com.apple.product-type.library.static'
		when :tool		then 'com.apple.product-type.tool'
	    end
	end
    end
end
