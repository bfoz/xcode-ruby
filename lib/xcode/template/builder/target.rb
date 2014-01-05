require_relative '../build_phase'

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

# @group Build Phases
		# Create a ShellScript build phase
		# @param shell [String]	The shell to use to execute the script
		# @param content [String]   The script contents
		def script(shell, content)
		    @target.push BuildPhase.script(shell, content)
		end
# @endgroup

		def method_missing(method, *args, &block)
		    if @target.respond_to?((method.to_s + '=').to_sym)
			@target.send (method.to_s + '=').to_sym, *args
		    else
			super
		    end
		end
	    end
	end
    end
end
