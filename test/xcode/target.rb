require 'minitest/autorun'
require 'xcode/target'

describe Xcode::Target do
    subject { Xcode::Target.new }

    it 'must have a name attribute' do
	subject.name = 'name'
	subject.name.must_equal 'name'
    end
end
