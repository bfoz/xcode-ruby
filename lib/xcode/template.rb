require 'fileutils'
require 'pathname'

require_relative 'template/option'

module Xcode
    class Template
        XCODE3_PROJECT_TEMPLATE_UNIT_KIND = 'Xcode.Xcode3.ProjectTemplateUnitKind'
        IDEKIT_TEXT_SUBSTITUTION_FILE_TEMPLATE_KIND = 'Xcode.IDEKit.TextSubstitutionFileTemplateKind'

        # @!attribute identifier
        #   @return [String]    The template identifier string
        attr_accessor :identifier

	# @!attribute name
	#   @return [String]	The name of the template's .xctemplate directory (without the suffix).
	attr_accessor :name

	# @!attribute concrete
	#   @return [Boolean]	A concrete template will appear in the New Project Assistant. Non-concrete (ie. abstract) templates can be used as ancestors of other templates.
        attr_accessor :concrete

	# @!attribute description
	#   @return [String]	A description of the template. Appears at the bottom of the New Project Template dialog.
	attr_accessor :description

	# @!attribute kind
	#   @return [String]	A {Template} can be either a Project Template (Xcode.Xcode3.ProjectTemplateUnitKind) or a File Template (Xcode.IDEKit.TextSubstitutionFileTemplateKind)
	attr_accessor :kind

	# @!attribute macOSX
	#   @return [Boolean]	Is the {Template} valid for Mac OS X?
	attr_accessor :macOSX

	# @!attribute iOS
	#   @return [Boolean]	Is the {Template} valid for iOS?
	attr_accessor :iOS

	# @!attribute sort_order
	#   @return [Number]	Change the {Template}'s sort order when displayed in the New Project dialog. Templates are sorted by category, then sort_order (highest to lowest), and then alphabetically. 
	attr_accessor :sort_order

	# Create a new {Template} with the provided name and identifier
	# @param identifier [String]	The template identifier string
	# @param name [String]	The name of the template's .xctemplate directory (without the extension).
        def initialize(**options)
            @identifier = options[:identifier] || options[:id]
	    @name = options[:name]
	    @sort_order = 1
        end

	# @!attribute platforms
	#   @return [Array<String>] The platforms that the template supports
	def platforms
	    [iOS ? 'com.app.platform.iphoneos' : nil, macOSX ? 'com.app.platform.macosx' : nil].compact
	end

	def platforms=(*args)
	    args.flatten!
	    args.compact!
	    return if args.length > 2
	    self.iOS = args.include?('com.app.platform.iphoneos')
	    self.macOSX = args.include?('com.app.platform.macosx')
	end

	def to_h
	    {'Description' => description,
	     'Kind' => kind,
	     'Identifier' => identifier,
	     'Concrete' => concrete,
	     'SortOrder' => sort_order,
	     'Platforms' => platforms,
	    }
	end

	# Install the template into the user's template directory
	def install(path=nil)
	    template_path = Pathname.new '~/Library/Developer/Xcode/Templates'
	    base_path = template_path.join(self.kind_of?(ProjectTemplate) ? 'Project Templates' : 'File Templates')
	    if self.kind_of?(ProjectTemplate)
		if self.macOSX && !self.iOS
		    base_path = base_path.join('Mac')
		end
	    end
	    if path
		base_path = base_path.join(path)
	    end
	    write(base_path.expand_path.to_s)
	end

	# Write the template structure into the given directory path
	# @param path [String] The path to the directory to write the {Template} to
	def write(path)
	    root_path = File.join(path, name + '.xctemplate')
	    FileUtils.mkdir_p(root_path, mode:0700)

	    # Write TemplateInfo.plist
	    File.open(File.join(root_path, 'TemplateInfo.plist'), 'w') do |f|
		f.puts '<?xml version="1.0" encoding="UTF-8"?>'
		f.puts '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
		f.puts "<plist version='1.0'>"
		f.puts string_for_value(to_h, 1)
		f.puts '</plist>'
	    end
	end

	private

	# @return [String]
	def string_for_value(value, indent=0)
	    indentation = ' ' * (4 * indent)
	    case value
		when TrueClass, FalseClass
		    indentation + (value ? '<true/>' : '<false/>') + "\n"
		when Array
		    if value.length != 0
			values = value.map {|v| string_for_value(v, indent+1) }.compact
			[indentation + '<array>' + "\n", *values, indentation + '</array>' + "\n"].join
		    end
		when Hash
		    output = indentation + '<dict>' + "\n"
		    key_indentation = indentation + (' ' * 4)
		    value.each do |key, v|
			next unless v
			s = string_for_value(v, indent + 1)
			next unless s
			output += key_indentation + "<key>#{key}</key>\n"
			output += s
		    end
		    output += indentation + '</dict>' + "\n"
		when Integer
		    indentation + "<integer>#{value.to_s}</integer>\n"
		when String
		    indentation + '<string>' + value.encode(:xml => :text) + "</string>\n"
		else
		    string_for_value(value.to_h, indent) if value.respond_to? :to_h
	    end
	end
    end
end
