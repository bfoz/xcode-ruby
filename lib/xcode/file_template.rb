require_relative 'template'

module Xcode
    class FileTemplate < Template
	def initialize
	    super
	    @kind = Template::IDEKIT_TEXT_SUBSTITUTION_FILE_TEMPLATE_KIND
	end
    end
end
