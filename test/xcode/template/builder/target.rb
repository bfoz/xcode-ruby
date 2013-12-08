require 'minitest/autorun'
require 'xcode/template/builder/target'

describe Xcode::Template::Builder::Target do
    subject { Xcode::Template::Builder::Target.new }

    it 'must create a Target with a name' do
	subject.build('test target').name.must_equal 'test target'
    end

    it 'must not have a Target Type' do
	subject.build.target_type.must_be_nil
    end

    it 'must have an aggregate command' do
	subject.build { aggregate }.target_type.must_equal :aggregate
    end

    it 'must have a legacy command' do
	subject.build { legacy }.target_type.must_equal :legacy
    end
end
