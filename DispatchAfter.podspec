Pod::Spec.new do |s|

  s.name         = "DispatchAfter"
  s.version      = "0.1.2"
  s.summary      = "Simple and modern way to make delayed calls with ability to cancel them"

  s.description  = <<-DESC
                   DispatchAfter is a simple and modern way to make delayed calls with ability to cancel them.
                   It written in Swift and can be used in both Swift and Objective-C projects.
                   DESC

  s.homepage     = "https://github.com/vGubriienko/SFDispatchAfter"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Viktor Gubriienko" => "super.ios.dev@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/vGubriienko/SFDispatchAfter.git", :tag => "0.1.2" }

  s.source_files = "SFDispatchAfter/SFDispatchAfter.swift"

  s.framework    = "Foundation"

  s.requires_arc = true

end
