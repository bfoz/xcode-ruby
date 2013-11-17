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

    it 'must have an iOS platform attribute' do
	subject.platforms.must_equal []
	subject.iOS = false
	subject.platforms.must_equal []
	subject.iOS = true
	subject.platforms.must_equal ['com.app.platform.iphoneos']
    end

    it 'must have an macOSX platform attribute' do
	subject.platforms.must_equal []
	subject.macOSX = false
	subject.platforms.must_equal []
	subject.macOSX = true
	subject.platforms.must_equal ['com.app.platform.macosx']
    end

    describe 'when setting the platforms attribute' do
	describe 'when setting both platforms' do
	    it 'must set both flags' do
		subject.platforms = ['com.app.platform.iphoneos', 'com.app.platform.macosx']
		subject.iOS.must_equal true
		subject.macOSX.must_equal true
	    end
	end

	describe 'when setting the iOS platform' do
	    before do
		subject.platforms = 'com.app.platform.iphoneos'
	    end

	    it 'must set the iOS flag' do
		subject.iOS.must_equal true
	    end

	    it 'must clear the OS X flag' do
		subject.macOSX.must_equal false
	    end
	end

	describe 'when setting the Mac OS X platform' do
	    before do
		subject.platforms = 'com.app.platform.macosx'
	    end

	    it 'must clear the iOS flag' do
		subject.iOS.must_equal false
	    end

	    it 'must set the OS X flag' do
		subject.macOSX.must_equal true
	    end
	end

	describe 'when setting the iOS platform with an array' do
	    before do
		subject.platforms = ['com.app.platform.iphoneos']
	    end

	    it 'must set the iOS flag' do
		subject.iOS.must_equal true
	    end

	    it 'must clear the OS X flag' do
		subject.macOSX.must_equal false
	    end
	end

	describe 'when setting the Mac OS X platform with an array' do
	    before do
		subject.platforms = ['com.app.platform.macosx']
	    end

	    it 'must clear the iOS flag' do
		subject.iOS.must_equal false
	    end

	    it 'must set the OS X flag' do
		subject.macOSX.must_equal true
	    end
	end

	describe 'when setting an empty array' do
	    it 'must clear both flags' do
		subject.platforms = []
		subject.iOS.must_equal false
		subject.macOSX.must_equal false
	    end
	end

	describe 'when setting the property to nil' do
	    it 'must clear both flags' do
		subject.platforms = nil
		subject.iOS.must_equal false
		subject.macOSX.must_equal false
	    end
	end

	describe 'when attempting to set too many platforms' do
	    it 'must do nothing' do
		subject.iOS = true;
		subject.macOSX = true
		subject.platforms = ['a', 'b', 'c']
		subject.iOS.must_equal true
		subject.macOSX.must_equal true
	    end
	end
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
