require_relative 'option_builder'
require_relative 'builder/file'
require_relative 'builder/target'

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

	    # @param ancestor_identifier [String]	the ancestor to add to the {Template}
	    def ancestor(ancestor_identifier)
		@template.ancestors.push ancestor_identifier
	    end

	    # Set the {Template} to be concrete or abstract
	    # @param concrete [Boolean] defaults to true
	    def concrete(concrete=true)
		@template.concrete = concrete
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
	    # @param path	[String] the file's path
	    # @param text	[String] the file's contents
	    def file(path, text=nil, &block)
		if block_given?
		    @template.add_file_definition Builder::File.new.build(@template, path, text, &block)
		else
		    @template.add_file path, text
		end
	    end

	    # Set the platform type to iOS
	    def iOS
		@template.iOS = true
	    end

	    # Set the platform type to Mac OS X
	    def macOSX
		@template.macOSX = true
	    end

	    # Create a new {Option}
	    # @param type [Symbol]  The type of the new {Option}
	    # @param name [String]  The name of the {Option}
	    def option(type, name=nil, &block)
		@template.add_option OptionBuilder.new.build(type, name, &block)
	    end

	    # Create a new named {Target}
	    # @param name [String]  the name of the new {Target}
	    # @return [Target]
	    def target(name, &block)
		@template.add_target Builder::Target.new.build(name, &block)
	    end

	    # @group Options

	    # Create a new Popup {Option}
	    # @param name   [String]	the display name of the {Option}
	    def popup(name=nil, &block)
		option(:popup, name, &block)
	    end

	    def static(&block)
		option(:static, &block)
	    end

	    def text(&block)
		option(:text, &block)
	    end
	    # @endgroup

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

	    def method_missing(method, *args, &block)
		if @template.respond_to?((method.to_s + '=').to_sym)
		    @template.send (method.to_s + '=').to_sym, *args
		else
		    super
		end
	    end
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
    end
end
