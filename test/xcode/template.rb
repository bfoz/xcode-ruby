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

    it 'must be concrete or not' do
	subject.concrete = true
	subject.concrete.must_equal true
	subject.concrete = false
	subject.concrete.must_equal false
    end

    describe 'when generating a hash' do
	let(:hash) { subject.to_hash }

	it 'must have an identifier' do
	    hash['Identifier'].must_equal 'net.bfoz.test_template'
	end

	describe 'concrete' do
	    it 'must be true' do
		subject.concrete = true
		subject.to_hash['Concrete'].must_equal true
	    end

	    it 'must be false' do
		subject.concrete = false
		subject.to_hash['Concrete'].must_equal false
	    end

	    it 'must be neither true nor false' do
		subject.to_hash['Concrete'].must_be_nil
	    end
	end
    end
end
