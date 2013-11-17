require 'fileutils'
require 'rexml/document'

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

        attr_accessor :concrete, :description, :kind, :sorter_order

	# Create a new {Template} with the provided name and identifier
	# @param identifier [String]	The template identifier string
	# @param name [String]	The name of the template's .xctemplate directory (without the extension).
        def initialize(**options)
            @identifier = options[:identifier] || options[:id]
	    @name = options[:name]
        end

	def to_hash
	    {'Description' => description, 'Kind' => kind, 'Identifier' => identifier, 'Concrete' => concrete}
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
		    REXML::Element.new('array').tap do |element|
			value.each.compact {|v| element.add_element(element_for_value(v)) }
		    end
		when Hash
		    REXML::Element.new('dict').tap do |element|
			value.each do |key, v|
			    next unless v
			    element.add_element('key').text = key
			    element.add_element(element_for_value(v))
			end
		    end
		when String
		    REXML::Element.new('string').tap {|element| element.text = value }
	    end
	end
    end
end
