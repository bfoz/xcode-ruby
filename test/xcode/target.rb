require 'minitest/autorun'
require 'xcode/target'

describe Xcode::Target do
    subject { Xcode::Target.new }

    it 'must have a name attribute' do
	subject.name = 'name'
	subject.name.must_equal 'name'
    end

    describe 'when generating a hash' do
	let(:hash) { subject.to_hash }

	it 'must not have a type' do
	    hash['TargetType'].must_be_nil
	end

	it 'must have a Name' do
	    subject.name = 'test name'
	    subject.to_hash['Name'].must_equal 'test name'
	end

	it 'must support Aggregate type' do
	    subject.target_type = :aggregate
	    subject.to_hash['TargetType'].must_equal 'Aggregate'
	end

	it 'must support Legacy type' do
	    subject.target_type = :legacy
	    subject.to_hash['TargetType'].must_equal 'Legacy'
	end
    end
end
