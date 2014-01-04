require 'minitest/autorun'
require 'xcode/template/option_builder'

describe Xcode::Template::PopupItemBuilder do
    subject { Xcode::Template::PopupItemBuilder.new }

    it 'must build a Value with a name' do
	subject.build('test_name').must_be_instance_of(Xcode::Template::Option::Value)
	subject.build('test_name').name.must_equal 'test_name'
    end

    it 'must set project variables' do
	item = subject.build('name') { set 'VARIABLE' => 'value' }
	item.settings['VARIABLE'].must_equal 'value'
	item.to_h['Project']['SharedSettings']['VARIABLE'].must_equal 'value'
    end

    describe 'when generating a hash' do
	let(:hash) { subject.build('name').to_h }

	it 'must not have Shared Project Settings' do
	    hash['Project'].must_be_nil
	end

	it 'must not have Configurations' do
	    skip
	    hash['Project'].has_key?('Configurations').must_equal false
	end
    end
end
