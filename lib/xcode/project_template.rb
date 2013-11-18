require_relative 'template'

module Xcode
    class ProjectTemplate < Template
        # @!attribute [r] ancestors
        #   @return [Array<String>] Type identifiers of the template's ancestor templates
        attr_reader :ancestors

        # @!attribute [r] definitions
        #   @return [Hash]  Definitions
        attr_reader :definitions

        # @!attribute [r] nodes
        #   @return [Array<String>] Nodes represent files that will be created in the generated project
        attr_reader :nodes

	# @!attribute options
	#   @return [Array] Options are controls that show up in the New Project Assistant
	attr_reader :options

        attr_reader :allowed_types, :targets
        attr_reader :project

        def initialize(**options)
            super
            @ancestors = []
            @definitions = {}
            @kind = Template::XCODE3_PROJECT_TEMPLATE_UNIT_KIND
	    @nodes = []
	    @options = []
        end

	def to_hash
	    super.merge({'Ancestors' => ancestors, 'Options' => options})
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
