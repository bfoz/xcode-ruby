require_relative 'template'

module Xcode
    class FileTemplate < Template
	# @!attribute [r] allowed_types
	#   @return [Array<String>] Limit the extensions of any filenames entered by the user to the specified list
	attr_reader :allowed_types

	def initialize
	    super
	    @allowed_types = []
	    @kind = Template::IDEKIT_TEXT_SUBSTITUTION_FILE_TEMPLATE_KIND
	end

	def to_h
	    super.merge({'AllowedTypes' => allowed_types})
	end
    end
end
