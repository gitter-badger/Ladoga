Pod::Spec.new do |s|
  s.name         = "Ladoga"
  s.version      = "0.2.2"
  s.summary      = "Lightweight HTTP server framework written in Objective-C."
  
  s.description  = "Ladoga is an lightweight and easy-to-use HTTP framework that makes it possible to write web-applications in Objective-C."

  s.homepage     = "http://aperechnev.github.io/Ladoga/"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Alexander Perechnev" => "herfleisch@me.com" }
  s.source       = { :git => "https://github.com/aperechnev/Ladoga.git", :tag => "0.2.2" }

  s.platform     = :osx, "10.11"
  s.source_files = 'Ladoga/Ladoga/*.{h,m}'
  s.requires_arc = true
end
