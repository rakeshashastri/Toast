#
# Be sure to run `pod lib lint Toast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Toast"
  s.version          = "1.0.0"
  s.summary          = "Toast for iOS"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Toast for iOS."
  s.homepage         = "https://github.com/rakeshashastri/Toast.git"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license      = { :type => "MIT", :text => <<-LICENSE
  MIT License
 Copyright (c) 2018 Rakesha Shastri
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE
 LICENSE
}
  s.author           = { "Rakesha Shastri" => "rakesha.shastri13@gmail.com" }
  s.source           = { :git => "https://github.com/rakeshashastri/Toast.git", :tag => s.version.to_s }
  # s.social_media_url = "https://twitter.com/<TWITTER_USERNAME>"

  s.ios.deployment_target = "9.0"

  s.source_files = "native/Toast/Toast/*.{swift}"
  s.ios.resource_bundle = { 'Toast' => 'native/Toast/Toast/*.xcassets'}
  # s.public_header_files = "Pod/Classes/**/*.h"
  s.frameworks = "UIKit"
  s.swift_version = "4.0"
  s.module_name = "Toast"
end
