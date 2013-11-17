require 'minitest/autorun'
require 'xcode/project_template'

describe Xcode::ProjectTemplate do
    subject { Xcode::ProjectTemplate.new }

    it "must have an empty array of ancestors" do
	subject.ancestors.must_be_kind_of Array
        subject.ancestors.empty?.must_equal true
    end

    it 'must have an empty hash of definitions' do
        subject.definitions.empty?.must_equal true
    end

    it 'must have an empty array of nodes' do
        subject.nodes.empty?.must_equal true
    end

    describe "when adding a resource file" do
        before do
            subject.add_file 'MyFile.m'
        end

        it 'must add a definition' do
            definition = subject.definitions['MyFile.m']
            definition.wont_be_nil
            definition['Group'].must_be_nil
            definition['Path'].must_equal 'MyFile.m'
            definition['TargetIndices'].must_be_nil
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'MyFile.m'
        end
    end

    describe 'when adding a file with a path' do
        before do
            subject.add_file 'MyFiles/MyFile.m'
        end

        it 'must add a definition with a group' do
            definition = subject.definitions['MyFiles/MyFile.m']
            definition.wont_be_nil
            definition['Group'].must_equal 'MyFiles'
            definition['Path'].must_equal 'MyFiles/MyFile.m'
            definition['TargetIndices'].must_be_nil
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'MyFiles/MyFile.m'
        end
    end

    describe 'when adding a file to a subgroup' do
        before do
            subject.add_file 'Classes/MyClass/MyFile.m'
        end

        it 'must add a definition with a subgroup' do
            definition = subject.definitions['Classes/MyClass/MyFile.m']
            definition.wont_be_nil
            definition['Group'].must_equal ['Classes', 'MyClass']
            definition['Path'].must_equal 'Classes/MyClass/MyFile.m'
            definition['TargetIndices'].must_be_nil
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'Classes/MyClass/MyFile.m'
        end
    end

    describe "when adding a non-resource file" do
        before do
            subject.add_file 'MyFile.m'
        end

        it 'must add a definition' do
            definition = subject.definitions['MyFile.m']
            definition.wont_be_nil
            definition['Group'].must_be_nil
            definition['Path'].must_equal 'MyFile.m'
#            definition['TargetIndices'].must_be :empty?
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'MyFile.m'
        end
    end

    describe 'when generating a hash' do
	let(:hash) { subject.to_hash }

	it 'must have a kind' do
	    hash['Kind'].must_equal Xcode::Template::XCODE3_PROJECT_TEMPLATE_UNIT_KIND
	end
    end
end
