Pod::Spec.new do |spec|

  spec.name         = "CieloBinQuery"
  spec.version      = "0.0.3"
  spec.summary      = "Biblioteca de consulta de cartões de crédito"

  spec.description  = <<-DESC
  Biblioteca Cielo/Braspag de consulta de cartões de crédito utilizando o bin.
                   DESC

  spec.homepage     = "https://github.com/DeveloperCielo/cielo-bin-query-ios"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  spec.author             = { "Jeferson F. Nazario" => "jefnazario@gmail.com" }
  # Or just: spec.author    = "Jeferson F. Nazario"
  # spec.authors            = { "Jeferson F. Nazario" => "jefnazario@gmail.com" }
  spec.social_media_url   = "https://twitter.com/jefnazario"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/DeveloperCielo/cielo-bin-query-ios.git", :tag => "#{spec.version}" }
  spec.swift_version = "5.0"


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "BinQuery/BinQuery/**/*.{h,m,swift,framework}"
  spec.dependency 'CieloOAuth'
  spec.exclude_files = "BinQuery/Example/**/*.*"
end
