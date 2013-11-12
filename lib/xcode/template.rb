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

        def initialize(**options)
            @identifier = options[:identifier] || options[:id]
	    @name = options[:name]
        end
    end
end
