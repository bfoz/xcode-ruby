require 'minitest/autorun'
require 'xcode/template'

describe Xcode::Template do
    subject { Xcode::Template.new id:'net.bfoz.test_template', name:'TestTemplate' }

    it 'must have an identifier' do
        subject.identifier.must_equal 'net.bfoz.test_template'
    end

    it "must have a name" do
	subject.name.must_equal 'TestTemplate'
    end
end
