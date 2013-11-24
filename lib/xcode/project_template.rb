require_relative 'template'
require_relative 'template/definition'

module Xcode
    class ProjectTemplate < Template
        # @!attribute [r] ancestors
        #   @return [Array<String>] Type identifiers of the template's ancestor templates
        attr_reader :ancestors

	# @!attribute [r] configurations
	#   @return [Hash]  Build configurations
	attr_reader :configurations

        # @!attribute [r] definitions
        #   @return [Hash]  Definitions
        attr_reader :definitions

        # @!attribute [r] nodes
        #   @return [Array<String>] Nodes represent files that will be created in the generated project
        attr_reader :nodes

	# @!attribute options
	#   @return [Array] Options are controls that show up in the New Project Assistant
	attr_reader :options

	# @!attribute [r] settings
	#   @return [Hash]  Settings shared by all of the Project's configurations
	attr_reader :settings

	# @!attribute [r] targets
	#   @return [Array] Build targets
        attr_reader :targets

        def initialize(**options)
            super
            @ancestors = []
	    @configurations = Hash.new({})
            @definitions = {}
            @kind = Template::XCODE3_PROJECT_TEMPLATE_UNIT_KIND
	    @nodes = []
	    @options = []
	    @settings = {}
	    @targets = []
        end

	def to_hash
	    super.merge({'Ancestors' => ancestors,
			 'Options' => options,
			 'Project' => {'SharedSettings' => settings, 'Configurations' => configurations},
			 'Targets'  => targets,
			 'Definitions' => definitions})
	end

        def add_file(path)
	    definitions[path] = Definition.new path
	    nodes.push path
        end

	def add_option(**options)
	    @options.push Option.new(**options)
	end
    end
end
