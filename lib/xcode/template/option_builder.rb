module Xcode
    class Template
	class OptionBuilder
	    def build(type, name=nil, &block)
		@option = Option.new(type: type, name: name)
		instance_eval(&block) if block_given?
		@option
	    end

	    def persisted(persisted=true)
		@option.persisted = persisted
	    end

	    def required(required=true)
		@option.required = required
	    end

	    def item(name, &block)
		@option.push PopupItemBuilder.new.build(name, &block)
	    end

	    def method_missing(method, *args, &block)
		if @option.respond_to?((method.to_s + '=').to_sym)
		    @option.send (method.to_s + '=').to_sym, *args
		else
		    super
		end
	    end
	end

	class PopupItemBuilder
	    def build(name, &block)
		@item = Option::Value.new(name)
		instance_eval &block if block_given?
		@item
	    end

	    # Set variables that are shared by all of the project's configurations
	    # @param args [Hash]
	    def set(*args)
		@item.set *args
	    end
	end
    end
end