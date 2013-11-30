module Xcode
    class Template
	class ProjectBuilder
	    def self.build(*args, **options, &block)
		self.new.build(*args, **options, &block)
	    end

	    def build(*args, **options, &block)
		@template = Xcode::ProjectTemplate.new(*args, **options)
		instance_eval(&block) if block_given?
		@template
	    end

	    # Create a new named configuration and evaluate the given block
	    # @param name [String]  the name of the new configuration
	    # @return [Hash]
	    def configuration(name, *args, &block)
		if block_given?
		    @template.configurations[name] = ConfigurationBuilder.new.build(&block)
		else
		    @template.configurations[name].merge! *args
		end
		@template.configurations[name]
	    end

	    # Add a {Definition}
	    # @param [Hash]
	    def define(*args)
		@template.definitions.merge! *args
	    end

	    # Add a template file
	    # @param path [String]
	    def file(path, &block)
		if block_given?
		    @template.add_file_definition FileBuilder.new.build(@template, path, &block)
		else
		    @template.add_file path
		end
	    end

	    # Set the {Template}'s identifier
	    # @param identifier [String]
	    def identifier(id)
		@template.identifier = id
	    end

	    # Set the {Template}'s name
	    # @param name [String]
	    def name(name)
		@template.name = name
	    end

	    # Create a new {Option}
	    # @param type [Symbol]  The type of the new {Option}
	    def option(type, &block)
		@template.add_option OptionBuilder.new.build(type, &block)
	    end

	    # Create a new named {Target}
	    # @param name [String]  the name of the new {Target}
	    # @return [Target]
	    def target(name, &block)
		@template.add_target TargetBuilder.new.build(name, &block)
	    end

	    # @group Project Settings

	    # Set a project setting from the value of a block
	    # @param name [String]  the name of the setting
	    def let(name, &block)
		@template.settings[name] = block.call
	    end

	    # Set a project-level setting from a {Hash}
	    def set(*args)
		@template.set *args
	    end
	    # @endgroup
	end

	class ConfigurationBuilder
	    def build(&block)
		@configuration = {}
		instance_eval(&block)
		@configuration
	    end

	    def set(*args)
		@configuration.merge! *args
	    end
	end

	class FileBuilder
	    def build(template, path, &block)
		@template = template
		@definition = Definition.new path
		instance_eval(&block)
		@definition
	    end

	    # Specify the {Target}s that the file belongs to
	    # @param target [Symbol,Target,String]	Either the symbol :all to indicate all targets, the name of a {Target} in the targets array, or a {Target} object (must already have been added to the template)
	    def targets(target)
		case target
		    when Symbol
			@definition.target_indices = []
		    when Target
			index = @template.targets.index(target)
			if index
			    @definition.target_indices ||= []
			    @definition.target_indices.push index
			end
		    when String
			index = @template.targets.index {|t| t.name == target }
			if index
			    @definition.target_indices ||= []
			    @definition.target_indices.push index
			end
		end
	    end

	    def method_missing(method, *args, &block)
		if @definition.respond_to?((method.to_s + '=').to_sym)
		    @definition.send (method.to_s + '=').to_sym, *args
		else
		    super
		end
	    end
	end

	class OptionBuilder
	    def build(type, &block)
		@option = Option.new(type: type)
		instance_eval(&block)
		@option
	    end

	    def persisted(persisted=true)
		@option.persisted = persisted
	    end

	    def required(required=true)
		@option.required = required
	    end

	    def method_missing(method, *args, &block)
		if @option.respond_to?((method.to_s + '=').to_sym)
		    @option.send (method.to_s + '=').to_sym, *args
		else
		    super
		end
	    end
	end

	class TargetBuilder
	    def build(name, &block)
		@target = Target.new(name)
		instance_eval &block
		@target
	    end

	    # Create a new named configuration and evaluate the given block
	    # @param name [String]  the name of the new configuration
	    def configuration(name, *args, &block)
		if block_given?
		    @target.configurations[name] = ConfigurationBuilder.new.build(&block)
		elsif args && (0 != args.size)
		    @target.configurations[name].merge! *args
		end
		@target.configurations[name]
	    end

	    # Set a project setting from the value of a block
	    # @param name [String]  the name of the setting
	    def let(name, &block)
		@target.settings[name] = block.call
	    end

	    # Set a project-level setting from a {Hash}
	    def set(*args)
		@target.set *args
	    end
	end
    end
end
