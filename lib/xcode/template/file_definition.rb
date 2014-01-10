module Xcode
    class Template
	# {File} represents a file to be included in a {ProjectTemplate}
	class FileDefinition
	    # @!attribute content
	    #   @return [String]  The file's contents
	    attr_accessor :content

	    # @!attribute name
	    #   @return [String]  The file's name
	    attr_accessor :name

	    # @!attribute path
	    #   @return [String]    The file's full path, including name. If no file content is provided in the template plist, then a file must exist at this path relative to the enclosing .xctemplate directory.
	    attr_accessor :path

	    # @!attribute placeholders
	    #   @return [Hash]  The placeholders defined for the file
	    attr_accessor :placeholders

	    # @!attribute prefix
	    #   @return [String]    Text to be prepended to the file
	    attr_accessor :prefix

	    # @!attribute suffix
	    #   @return [String]    Text to be appended to the file
	    attr_accessor :suffix

	    # @!attribute target_indices
	    #   @return [Array]	    Indexes into the Targets array of the Targets to add the file to.
	    attr_accessor :target_indices

	    # @param path   [String]  The file's full path
	    # @param content [String]	The file's contents, if any
	    def initialize(path, content=nil)
		@content = content
		_, @name = File.split(path)
		@path = path
		@placeholders = {}
	    end

	    # @return [Hash]
	    def definition
		d = if content
		    {path => content}
		else
		    {	path => {   'Path' => path,
				    'Beginning' => prefix,
				    'End' => suffix,
				    'Group' => group,
				    'TargetIndices' => target_indices
				}
		     }
		end

		placeholders.reduce(d) do |memo, (k, v)|
		    memo.merge({[path, k].join(':') => {'Beginning' => v[:prefix],
							'End' => v[:suffix],
							'Indent' => v[:indent] }})
		end
	    end

	    # @!attribute [r] group
	    #   @return [Array,String]  The group to add the file to. A single, top-level, group is specified with a String. A nested group can be specified with an Array.
	    def group
		dirname, _ = File.split(path)
		if dirname && (0 != dirname.length) && ('.' != dirname)
		    components = dirname.split(File::SEPARATOR)
		    (components.length > 1) ? components : components.first
		end
	    end

	    # @return [Array<String>]	The file nodes corresponding to this file
	    def nodes
		if placeholders.size > 0
		    placeholders.map {|k,v| [path, k].join(':') }
		else
		    path
		end
	    end

	    # @group Targets

	    # Shortcut for indicating that the file should be added to all {Target}s
	    def all_targets
		target_indices = []
	    end

	    # Shortcut for indicating that the file should not be added to any {Target}s
	    def no_targets
		target_indices = nil
	    end

	    # Indicate that the file should be added to the {Target} having the given index
	    # @param index [Number] The index of the {Target} that the file should be added to
	    def push_target_index(index)
		target_indices ||= []
		target_indices.push index
	    end

	    # @endgroup
	end
    end
end
