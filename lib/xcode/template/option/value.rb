module Xcode
    class Template
	class Option
	    class Value
		# @!attribute name
		#   @return [String]  the name to show in the popup menu
		attr_accessor :name

		def initialize(name)
		    @name = name
		end

		def to_h
		    {}
		end
	    end
	end
    end
end
