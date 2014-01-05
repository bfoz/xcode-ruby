module Xcode
    class Template
	class BuildPhase
	    # @!attribute content
	    #   @return [String]  The script
	    attr_accessor :content

	    # @!attribute shell
	    #   @return [String]  The path to the shell to use to execute the script
	    attr_accessor :shell

	    # !@attribute [r] type
	    #   @return [Symbol]    The build phase type (:script)
	    attr_reader :type

	    def self.script(shell, content)
		build_phase = self.new(:script)
		build_phase.content = content
		build_phase.shell = shell
		build_phase
	    end

	    # @param type [Symbol]  :script
	    def initialize(type)
		@type = type
	    end
	    def to_h
		case type
		    when :script
			{'Class'	=> 'ShellScript',
			 'ShellPath'	=> shell,
			 'ShellScript'	=> content}
		    else
			nil
		end
	    end
	end
    end
end
