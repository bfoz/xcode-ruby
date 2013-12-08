require 'minitest/autorun'
require 'xcode/template/option_builder'

describe Xcode::Template::OptionBuilder do
    subject { Xcode::Template::OptionBuilder.new }

    it 'must create an option of the specified type' do
	%i{build_setting class combo popup static text}.each {|type| subject.build(type).type.must_equal type }
    end

    it 'must have a persisted command' do
	subject.build(:text) { persisted }.persisted.must_equal true
	subject.build(:text) { persisted false }.persisted.must_equal false
    end

    it 'must have a required command' do
	subject.build(:text) { required }.required.must_equal true
	subject.build(:text) { required false }.required.must_equal false
    end

    it 'must build and add a value with a name' do
	option = subject.build(:popup) do
	    item 'test_item'
	end
	option.values.count.must_equal 1
	option.values.first.must_be_instance_of Xcode::Template::Option::Value
	option.values.first.name.must_equal 'test_item'
    end
end
