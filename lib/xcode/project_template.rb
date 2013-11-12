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
        #   @return [Array] Nodes
        attr_reader :nodes

        attr_reader :allowed_types, :platforms, :options, :targets
        attr_reader :project

        def initialize
            super
            @ancestors = []
            @definitions = {}
            @kind = Template::XCODE3_PROJECT_TEMPLATE_UNIT_KIND
	    @nodes = []
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
    end
end
