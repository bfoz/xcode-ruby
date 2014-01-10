require 'minitest/autorun'
require 'xcode/template/builder/file'

describe Xcode::Template::Builder::File do
    let(:template) { Xcode::Template.new }
    subject { Xcode::Template::Builder::File.new }

    it 'must create a File with a name' do
	subject.build(template, 'test file').name.must_equal 'test file'
    end

    it 'must not have any content yet' do
	subject.build(template, 'test file').content.must_be_nil
    end

    it 'must have a placeholder command' do
	subject.build(template, 'test file') { placeholder 'main' }.placeholders.size.must_equal 1
    end

    it 'must have a placeholder indent command' do
	subject.build(template, 'filename') do
	    placeholder('main') { indent 1 }
	end.placeholders['main'][:indent].must_equal 1
    end
end
