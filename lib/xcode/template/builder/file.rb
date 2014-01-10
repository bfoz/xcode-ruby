require_relative '../file_definition'

module Xcode
    class Template
	module Builder
	    # Build a new {FileDefinition}
	    class File
		def build(template, path, text=nil, &block)
		    @template = template
		    @definition = Definition.new path, text
		    @file = FileDefinition.new path, text
		    instance_eval(&block) if block_given?
		    @file
		end

		# Define a placeholder variable for the file
		def placeholder(name, &block)
		    @file.placeholders[name] = Builder::Placeholder.new.build(&block)
		end

		# Specify the {Target}s that the file belongs to
		# @param target [Symbol,Target,String]	Either the symbol :all to indicate all targets, the name of a {Target} in the targets array, or a {Target} object (must already have been added to the template)
		def targets(target)
		    case target
			when :all
			    @file.all_targets
			when :none
			    @file.no_targets
			when Target
			    index = @template.targets.index(target)
			    @file.push_target_index(index) if index
			when String
			    index = @template.targets.index {|t| t.name == target }
			    @file.push_target_index(index) if index
		    end
		end

		def method_missing(method, *args, &block)
		    if @file.respond_to?((method.to_s + '=').to_sym)
			@file.send (method.to_s + '=').to_sym, *args
		    else
			super
		    end
		end
	    end

	    class Placeholder
		def build(&block)
		    instance_eval(&block) if block_given?
		    {indent: @indent, prefix: @prefix, suffix: @suffix}
		end

		def prefix(a)
		    @prefix = a
		end

		def indent(a)
		    @indent = a
		end

		def suffix(a)
		    @suffix = a
		end
	    end
	end
    end
end
