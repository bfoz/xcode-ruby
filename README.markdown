# Xcode

[![Build Status](https://travis-ci.org/bfoz/xcode-ruby.png)](https://travis-ci.org/bfoz/xcode-ruby)

Manipulate and generate Xcode templates. This gem primarily supports Xcode 5, but it will probably work with Xcode 4 as well. Although, that hasn't been tested.

## Installation

Add this line to your application's Gemfile:

    gem 'xcode', github: 'bfoz/xcode-ruby'

And then execute:

    $ bundle

## Examples

This is how one might replicate the Base project template installed with Xcode 5, not that anyone would actually do such a crazy thing.

```ruby
require 'xcode'

Xcode::Template.project do
    name        'Base'
    identifier  'com.apple.dt.unit.base'

    set 'GCC_C_LANGUAGE_STANDARD'               => 'gnu99',
        'CLANG_CXX_LANGUAGE_STANDARD'           => 'gnu++0x',
        'CLANG_CXX_LIBRARY'                     => 'libc++',
        'GCC_WARN_ABOUT_RETURN_TYPE'            => 'YES_ERROR',
		'GCC_WARN_UNINITIALIZED_AUTOS'          => 'YES',
		'GCC_WARN_UNUSED_VARIABLE'              => 'YES',
		'GCC_WARN_UNUSED_FUNCTION'              => 'YES',
		'CLANG_WARN__DUPLICATE_METHOD_MATCH'    => 'YES',
		'CLANG_WARN_EMPTY_BODY'                 => 'YES',
		'CLANG_WARN_CONSTANT_CONVERSION'        => 'YES',
		'CLANG_WARN_INT_CONVERSION'             => 'YES',
		'CLANG_WARN_BOOL_CONVERSION'            => 'YES',
		'CLANG_WARN_ENUM_CONVERSION'            => 'YES',
		'CLANG_WARN_OBJC_ROOT_CLASS'            => 'YES_ERROR',
		'GCC_WARN_UNDECLARED_SELECTOR'          => 'YES',
		'GCC_WARN_64_TO_32_BIT_CONVERSION'      => 'YES',
		'CLANG_WARN_DIRECT_OBJC_ISA_USAGE'      => 'YES_ERROR',
		'CLANG_ENABLE_OBJC_ARC'                 => 'YES',
		'ALWAYS_SEARCH_USER_PATHS'              => 'NO'

    configuration 'Debug' do
        set 'GCC_OPTIMIZATION_LEVEL'        => '0',
            'GCC_PREPROCESSOR_DEFINITIONS'  => 'DEBUG=1 $(inherited)',
            'GCC_SYMBOLS_PRIVATE_EXTERN'    => 'NO',
            'COPY_PHASE_STRIP'              => 'NO',
            'GCC_DYNAMIC_NO_PIC'            => 'NO'
    end

    configuration 'Release', 'COPY_PHASE_STRIP' => 'YES', 'ENABLE_NS_ASSERTIONS' => 'NO'

    target '___PACKAGENAME___' do
        set 'PRODUCT_NAME' => '$(TARGET_NAME)'
        configuration 'Debug'
        configuration 'Release'
    end

    option :text do
        name        'Product Name'
        identifier  'productName'
        description "Your new product's name."
        placeholder 'ProductName'
        required
        persisted
    end

    option :text do
        name        'Company Identifier'
        identifier  'bundleIdentifierPrefix'
        description "Your company's bundle identifier prefix."
        placeholder 'com.yourcompany'
        required
    end

    option :static do
        name        'Bundle Identifier'
        identifier  'bundleIdentifier'
        description "Your new product's bundle identifier."
        default     '___VARIABLE_bundleIdentifierPrefix:bundleIdentifier___.___VARIABLE_productName:RFC1034Identifier___'
        persisted
    end

    file '___PACKAGENAME___-Prefix.pch' do
        group   'Supporting Files'
        targets :all
        prefix '//
//  Prefix header
//
//  The contents of this file are implicitly included at the beginning of every source file.
//
'
    end

    file '___PACKAGENAME___-Prefix.pch:objC' do
        prefix '#ifdef __OBJC__'
        suffix '#endif'
        indent 1
    end

    define '*:import:*' => '#import "___*___"'
    define '*:*:importFoundation' => '#import <Foundation/Foundation.h>'
    define '*:comments' => '//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//
'
end
```

## Template Locations

Xcode looks for templates in a number of locations. Starting with Xcode 4.3, the
system default templates are stored in the Xcode.app bundle. Custom templates
are stored in the user's Library directory.

There doesn't appear to be any way to install custom templates for all users
without modifying the app bundle. Modifying the app bundle breaks the bundle
signature, which prevents Xcode from launching.

All of the various Template directories share the same internal structure. Project
templates are stored in a 'Project Templates' subdirectory, while file templates
are in a 'File Templates' subdirectory.

### Custom templates
Custom templates can be found in the user's Library directory:
    ~/Library/Developer/Xcode/Templates/File Templates
    ~/Library/Developer/Xcode/Templates/Project Templates

Special project template directories:
    ~/Library/Developer/Xcode/Templates/Project Templates/Base
    ~/Library/Developer/Xcode/Templates/Project Templates/Mac

Subdirectories of the 'Project Templates' directory correspond to the project
categories that appear in the sidebar of the New Project dialog.

It appears that there are two special category directories called 'Base' and
'Mac', neither of which appears in the sidebar. However, the subdirectories of
each do appear in the normal fashion. The 'Mac' directory contains templates
that are only relevant to Mac OS X targets, whereas 'Base' contains abstract
templates that can be used as ancestors for other templates.

Regardless of where the templates are installed within 'Project Templates',
they seem to show up as both iOS and OS X templates in the New Project dialog.

### System templates
The Xcode app bundle has a Templates directory that mirrors the layout of the
user templates directory, but contains the default templates. The default iOS
templates are stored in the 'Platforms' directory. It's not clear if OS X
templates can also be stored in 'Platforms'. Nor is it clear if there can be
a corresponding platforms directory in ~/Library.

Mac OS X templates:
    /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates

iOS templates:
    /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates

## References

[Steffen Itterheim](http://github.com/LearnCocos2D)'s ['Xcode 4 Template Documentation'](http://www.learn-cocos2d.com/store/xcode4-template-documentation/),
though dated, is very thorough and was extremely helpful in fleshing out many
of the details. Well worth the cost.

[This post](http://blog.boreal-kiss.net/2011/03/11/a-minimal-project-template-for-xcode-4/)
got me thinking about this project again, and nudged me to finally create a
gem. It also reminded me that I had purchased Itterheim's documentation and
then never did anything with it. The first set of test cases were written from
the examples in this article.

Other userful references, in no particular order:
- http://meandmark.com/blog/2011/12/creating-custom-xcode-4-project-templates/
- http://meandmark.com/blog/2011/11/creating-custom-xcode-4-file-templates/
- http://rypearts.com/proof/bob/r1/2012/03/04/creating-custom-xcode-4-file-templates/
- http://sergeynezdoliy.blogspot.com/2013/03/creating-project-template-for-xcode-4x.html
- https://snipt.net/yonishin/about-xcode-4-project-template/
