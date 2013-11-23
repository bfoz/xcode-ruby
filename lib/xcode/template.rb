require 'fileutils'
require 'rexml/document'

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

	def to_hash
	    {'Description' => description,
	     'Kind' => kind,
	     'Identifier' => identifier,
	     'Concrete' => concrete,
	     'SortOrder' => sort_order,
	     'Platforms' => platforms,
	    }
	end

	# Write the template structure into the given directory path
	# @param path [String] The path to the directory to write the {Template} to
	def write(path)
	    root_path = File.join(path, name + '.xctemplate')
	    p root_path
	    FileUtils.mkdir_p(root_path, mode:0700)

	    # Write TemplateInfo.plist
	    File.open(File.join(root_path, 'TemplateInfo.plist'), 'w') do |f|
		document = REXML::Document.new('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">')
		plist = document.add_element('plist', {'version' => '1.0'})
		plist.add_element element_for_value(to_hash)

		# This is a hack to force REXML to output PCDATA text inline with the enclosing element
		formatter = REXML::Formatters::Pretty.new(4)
		formatter.compact = true
		formatter.write(document, f)
	    end
	end

	private

	# @return [REXML::Element]
	def element_for_value(value)
	    case value
		when TrueClass, FalseClass
		    REXML::Element.new( value ? 'true' : 'false')
		when Array
		    if value.length != 0
			REXML::Element.new('array').tap do |element|
			    value.compact.each {|v| element.add_element(element_for_value(v)) }
			end
		    end
		when Hash
		    if value.length != 0
			REXML::Element.new('dict').tap do |element|
			    value.each do |key, v|
				next unless v
				e = element_for_value(v)
				next unless e
				element.add_element('key').text = key
				element.add_element(e)
			    end
			end
		    end
		when String
		    REXML::Element.new('string').tap {|element| element.text = value }
		else
		    element_for_value(value.to_hash) if value.respond_to? :to_hash
	    end
	end
    end
end
