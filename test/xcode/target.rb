require 'minitest/autorun'
require 'xcode/target'

describe Xcode::Target do
    subject { Xcode::Target.new }

    it 'must have a name attribute' do
	subject.name = 'name'
	subject.name.must_equal 'name'
    end

    describe 'when generating a hash' do
	let(:hash) { subject.to_h }

	it 'must not have a type' do
	    hash['TargetType'].must_be_nil
	end

	it 'must have a Name' do
	    subject.name = 'test name'
	    subject.to_h['Name'].must_equal 'test name'
	end

	it 'must support Aggregate type' do
	    subject.target_type = :aggregate
	    subject.to_h['TargetType'].must_equal 'Aggregate'
	end

	it 'must support Legacy type' do
	    subject.target_type = :legacy
	    subject.to_h['TargetType'].must_equal 'Legacy'
	end

	it 'must support Build Phases' do
	    subject.push Xcode::Template::BuildPhase.script('/bin/sh', 'echo Bonjour!')
	    build_phase = subject.to_h['BuildPhases'].first
	    build_phase['Class'].must_equal 'ShellScript'
	    build_phase['ShellPath'].must_equal '/bin/sh'
	    build_phase['ShellScript'].must_equal 'echo Bonjour!'
	end
    end
end
