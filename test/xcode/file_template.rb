require 'minitest/autorun'
require 'xcode/file_template'

describe Xcode::FileTemplate do
    subject { Xcode::FileTemplate.new }

    it 'must be of the correct kind' do
	subject.kind.must_equal 'Xcode.IDEKit.TextSubstitutionFileTemplateKind'
    end
end
