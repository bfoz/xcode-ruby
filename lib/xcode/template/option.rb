require_relative 'option/value'

module Xcode
    class Template
	class Option
	    # @!attribute default
	    #	@return [String]    A default value to use no value has been specified
	    attr_accessor :default

	    # @!attribute description
	    #	@return [String]    A tooltip to display to when the user hovers over the input component
	    attr_accessor :description

	    # !@attribute fallback_header
	    #	@return [String]    When type == :class, the value to be used when the base class can't be determined
	    attr_accessor :fallback_header

	    # @!attribute identifier
	    #	@return [String]    The identifier of the variable to hold the {Option}'s value
	    attr_accessor :identifier

	    # @!attribute name
	    #	@return [String]    The text of the label associated with the input component
	    attr_accessor :name

	    # @!attribute order
	    #   @return [Integer]  {Option}s are displayed in the New Template dialog ordered according to this property. It provides rudimentary layout control.
	    attr_accessor :order

	    # @!attribute persisted
	    #	@return [Boolean]   Indicates that the value will be persisted by Xcode and used the next time the template is instantiated
	    attr_accessor :persisted

	    # @!attribute placeholder
	    #	@return [String]    Placeholder text to display in the input control
	    attr_accessor :placeholder

	    # @!attribute required
	    #	@return [Boolean]   Indicates that a valid value is required by the enclosign template
	    attr_accessor :required

	    # @!attribute suffixes
	    #	@return [Hash]	Suffixes to be automatically appended to filenames based on the class being subclassed
	    attr_accessor :suffixes

	    # @!attribute type
	    #	@return [Symbol]    Input type. Can be :class, :combo, :build_setting, :popup, :static, or :text.
	    attr_accessor :type

	    # @!attribute values
	    #	@return [Array]	    The values to display when the {Option} is a :combo, :popup, or :class.
	    attr_accessor :values

	    # @!attribute required_options
	    #	@return [Array]	    Used to enable or disable other {Option}s based on the value selected in a multi-value control (popups, etc)
	    attr_accessor :required_options

	    def self.new(**options)
		case options[:type]
		    when :popup
			PopupOption
		    else
			self
		end.allocate.tap {|object| object.send :initialize, **options }
	    end

	    def initialize(**options)
		@values = []
		options.each {|k,v| send(k.to_s+'=', v)}
	    end

	    # @return [String]	A variable that can be used in template files to insert the {Option}'s value
	    def macro
		"___VARIABLE_#{identifier}___"
	    end

	    # @return [String] the C-safe version of *macro*
	    def safe
		"___VARIABLE_#{identifier}:identifier___"
	    end

	    def to_h
		items = values.reduce({}) {|items, value| items[value.name] = value unless value.to_h.empty?; items}
		values_array = values.map {|v| v.name }
		{'Identifier' => identifier,
		 'Name' => name,
		 'Default' => default,
		 'Description' => description,
		 'EmptyReplacement' => placeholder,
		 'Required' => required,
		 'Type' => type.to_s,
		 'NotPersisted' => (persisted.nil? ? nil : !persisted),
		 'FallbackHeader' => fallback_header,
		 'SortOrder' => order,
		 'Suffixes' => suffixes,
		 'Units' => items.empty? ? nil : items,
		 'Values' => values_array.empty? ? nil : values_array,
		 'RequiredOptions' => required_options,
		}
	    end
	end

	class PopupOption < Option
	    def initialize(**options)
		super **options
		@type = :popup
	    end

	    def push(item)
		@values.push item
	    end
	end

	class StaticOption < Option
	    def initialize(**options)
		super **options
		@type = :static
	    end
	end

	class TextOption < Option
	    def initialize(**options)
		super **options
		@type = :text
	    end
	end
    end
end
