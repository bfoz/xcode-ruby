require_relative 'template'

module Xcode
    class ProjectTemplate < Template
	# @!attribute [r] allowed_types
	#   @return [Array<String>] Limit the extensions of any filenames entered by the user to the specified list
	attr_reader :allowed_types

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
	    @allowed_types = []
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
			 'AllowedTypes' => allowed_types,
			 'Targets'  => targets})
	end

        def add_file(path)
	    definition = {'Path' => path}

	    dirname, basename = File.split(path)
	    if dirname && (0 != dirname.length) && ('.' != dirname)
		components = dirname.split(File::SEPARATOR)
		definition['Group'] = (components.length > 1) ? components : components.first
	    end
	    definitions[path] = definition

	    nodes.push path
        end

	def add_option(**options)
	    @options.push Option.new(**options)
	end
    end
end
