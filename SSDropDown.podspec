
Pod::Spec.new do |s|

  s.name         = "SSDropDown"
  s.version      = "1.0"
  s.summary      = "Simple & customizable dropdown"

 
  s.description  = <<-DESC
                   * Dropdown support for both swift and objective C.
                   * Simple & customizable dropdown.
                   DESC

  s.homepage     = "https://github.com/shebinkoshy/DropDown.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author       = { "" => "Shebin Koshy" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/shebinkoshy/DropDown.git", :tag => "1.0" }


  s.source_files  = "*.{h,m}"

end
