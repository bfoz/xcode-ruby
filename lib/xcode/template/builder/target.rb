module Xcode
    class Template
	module Builder
	    class Target
		def build(name=nil, &block)
		    @target = Xcode::Target.new(name)
		    instance_eval &block if block_given?
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

		def aggregate
		    @target.target_type = :aggregate
		end

		def legacy
		    @target.target_type = :legacy
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
end
