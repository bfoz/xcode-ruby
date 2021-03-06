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

    it 'must create a new Hash when a new Configuration is set' do
	subject.configurations['Debug'].must_be_kind_of Hash
    end

    it 'must have no shared settings' do
	subject.settings.must_be :empty?
    end

    describe 'when adding a file' do
        before do
            subject.add_file 'MyFile.m'
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'MyFile.m'
        end

	it 'must hashify' do
	    hash = subject.to_h
	    hash['Definitions'].has_key?('MyFile.m').must_equal true
	    hash['Definitions']['MyFile.m']['Group'].must_be_nil
	    hash['Definitions']['MyFile.m']['Path'].must_equal 'MyFile.m'
	end
    end

    describe 'when adding a file with content' do
	before do
	    subject.add_file 'MyFile.m', 'Fancy content'
	end

	it 'must add a node' do
	    subject.nodes.first.must_equal 'MyFile.m'
	end

	it 'must hashify' do
	    subject.to_h['Definitions']['MyFile.m'].must_equal 'Fancy content'
	end
    end

    describe 'when adding a file with a path' do
        before do
            subject.add_file 'MyFiles/MyFile.m'
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'MyFiles/MyFile.m'
        end

	it 'must hashify' do
	    hash = subject.to_h
	    hash['Definitions'].has_key?('MyFiles/MyFile.m').must_equal true
	    hash['Definitions']['MyFiles/MyFile.m']['Group'].must_equal 'MyFiles'
	    hash['Definitions']['MyFiles/MyFile.m']['Path'].must_equal 'MyFiles/MyFile.m'
	end
    end

    describe 'when adding a file to a subgroup' do
        before do
            subject.add_file 'Classes/MyClass/MyFile.m'
        end

        it 'must add a node' do
            subject.nodes.first.must_equal 'Classes/MyClass/MyFile.m'
        end

	it 'must hashify' do
	    hash = subject.to_h
	    hash['Definitions'].has_key?('Classes/MyClass/MyFile.m').must_equal true
	    hash['Definitions']['Classes/MyClass/MyFile.m']['Group'].must_equal ['Classes', 'MyClass']
	    hash['Definitions']['Classes/MyClass/MyFile.m']['Path'].must_equal 'Classes/MyClass/MyFile.m'
	end
    end

    describe 'when generating a hash' do
	let(:hash) { subject.to_h }

	it 'must have a kind' do
	    hash['Kind'].must_equal Xcode::Template::XCODE3_PROJECT_TEMPLATE_UNIT_KIND
	end

	it 'must not have Shared Project Settings' do
	    hash['Project']['SharedSettings'].must_be_nil
	end

	it 'must generate an empty configuration if none have been set' do
	    subject.configurations.has_key?('Release').must_equal false
	    hash['Project'].has_key?('Configurations').must_equal true
	    hash['Project']['Configurations'].has_key?('Release').must_equal true
	end
    end

    describe 'when DSL' do
	it 'must create a new project template' do
	    template = Xcode::ProjectTemplate.new {}
	    template.must_be_kind_of Xcode::ProjectTemplate
	end

	it 'must create a new project template with a name' do
	    template = Xcode::Template.project('Test') {}
	    template.must_be_kind_of Xcode::ProjectTemplate
	    template.name.must_equal 'Test'
	end

	it 'must support setting of the name attribute' do
	    template = Xcode::Template.project do
		name 'Test'
	    end
	    template.name.must_equal 'Test'
	end

	it 'must support setting of the identifier attribute' do
	    Xcode::Template.project { identifier 'test.identifier' }.identifier.must_equal 'test.identifier'
	end

	it 'must add a project-level setting using the value of a block' do
	    Xcode::Template.project { let('SETTING') { 'yes' } }.settings['SETTING'].must_equal 'yes'
	end

	it 'must add a project-level setting using a hash' do
	    Xcode::Template.project { set('SETTING' => 'yes') }.settings['SETTING'].must_equal 'yes'
	end

	it 'must add a named configuration with a Hash' do
	    Xcode::Template.project { configuration('Debug', 'SETTING' => 'yes') }.configurations['Debug']['SETTING'].must_equal 'yes'
	end

	it 'must add a named configuration with a block' do
	    Xcode::Template.project do
		configuration('Debug') { set 'SETTING' => 'yes' }
	    end.configurations['Debug']['SETTING'].must_equal 'yes'
	end

	it 'must add a generic option with a type' do
	    Xcode::Template.project do
		option :text
	    end.options.count.must_equal 1
	end

	it 'must add a popup option' do
	    template = Xcode::Template.project do
		popup 'popup_option'
	    end
	    template.options.first.type.must_equal :popup
	    template.options.first.name.must_equal 'popup_option'
	end

	it 'must add a file with text' do
	    template = Xcode::Template.project do
		file 'test_file', 'test text'
	    end
	    template.files.size.must_equal 1
	end

	describe 'when adding a file with a placeholder' do
	    let(:template) do
		Xcode::Template.project do
		    file 'test_file' do
			placeholder 'test_placeholder' do
			    indent 1
			end
		    end
		end
	    end

	    it 'must have a file' do
		template.files.size.must_equal 1
	    end

	    it 'must hashify to the correct number of nodes' do
		template.nodes.size.must_equal 1
		template.nodes.first.must_equal 'test_file:test_placeholder'
	    end
	end
    end
end
