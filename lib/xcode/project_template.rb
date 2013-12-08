require_relative 'template'
require_relative 'template/builder'
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

	def self.new(*args, **options, &block)
	    if block_given?
		Xcode::Template::ProjectBuilder.build(*args, **options, &block)
	    else
		self.allocate.tap {|template| template.send :initialize, *args, **options }
	    end
	end

        def initialize(*args, **options)
            super
            @ancestors = []
	    @configurations = Hash.new {|h,k| h[k] = {} }
            @definitions = {}
            @kind = Template::XCODE3_PROJECT_TEMPLATE_UNIT_KIND
	    @nodes = []
	    @options = []
	    @settings = {}
	    @targets = []
        end

	# Xcoce 5.0.2 will crash if a Project Template doesn't include a 'Project' section with at least one configuration.
	def to_hash
	    super.merge({'Ancestors' => ancestors,
			 'Options' => options,
			 'Project' => { 'SharedSettings' => settings.empty? ? nil : settings,
					'Configurations' => configurations.empty? ? {'Release' => {}} : configurations},
			 'Targets'  => targets,
			 'Nodes' => nodes,
			 'Definitions' => definitions})
	end

	# Add a new file definition.
	# @param definition [Definition] the definition to add
	def add_file_definition(definition)
	    path = definition.path
	    definitions[path] = definition
	    nodes.push path
	end

        def add_file(path)
	    add_file_definition Definition.new path
        end

	def add_option(*args)
	    if args.first.is_a? Option
		@options.push args.first
	    else
		@options.push Option.new(*args)
	    end
	end

	# Add a {Target} to the targets array
	# @param target [Target]
	def add_target(target)
	    @targets.push target
	end

	# Set a project-level setting
	# @param args [Hash]
	def set(*args)
	    @settings.merge! *args
	end
    end

    class Template
	def self.project(name=nil, *args, **options, &block)
	    options[:name] = name if name
	    Xcode::Template::ProjectBuilder.build(*args, **options, &block)
	end
    end
end
