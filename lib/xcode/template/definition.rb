module Xcode
    class Template
	class Definition
	    # @!attribute indent
	    #   @return [Integer]   The indentation level of any text added between the header and footer text
	    attr_accessor :indent

	    # @!attribute group
	    #   @return [Array,String]  The group to add the file to. A single, top-level, group is specified with a String. A nested group can be specified with an Array.
	    attr_accessor :group

	    # @!attribute path
	    #   @return [String]    The path to a file in the .xctemplate directory that will be added to projects created from the {Template}
	    attr_accessor :path

	    # @!attribute path_type
	    #   @return [Symbol]    The root that the path attribute is considered to be relative to. Valid options: :absolute, :developer_dir, :group (default), :project
	    attr_accessor :path_type

	    # @!attribute prefix
	    #   @return [String]    Text to be prepended to the result of the macro expansion
	    attr_accessor :prefix

	    # @!attribute suffix
	    #   @return [String]    Text to be appended to the result of the macro expansion
	    attr_accessor :suffix

	    # @!attribute target_indices
	    #   @return [Array]	    Indexes into the Targets array of the Targets to add the file to.
	    attr_accessor :target_indices

	    # @!attribute text
	    #   @return [String]    The string to use when the definition is a simple macro expansion
	    attr_accessor :text

	    def initialize(path=nil, text=nil)
		@text = text
		if path
		    self.path = path

		    dirname, basename = File.split(path)
		    if dirname && (0 != dirname.length) && ('.' != dirname)
			components = dirname.split(File::SEPARATOR)
			self.group = (components.length > 1) ? components : components.first
		    end
		end
	    end

	    def to_h
		if text
		    text
		else
		    {'Path' => path,
		     'Beginning' => prefix,
		     'End' => suffix,
		     'Indent' => indent,
		     'Group' => group,
		     'TargetIndices' => target_indices,
		    }
		end
	    end
	end
    end
end
