Dir.chdir("../") do
  require './lib/latinum/version'

  Gem::Specification.new do |s|
    s.name = "latinum"
    s.version = Latinum::VERSION::STRING
    s.author = "Samuel Williams"
    s.email = "samuel.williams@oriontransfer.co.nz"
    s.homepage = "http://www.oriontransfer.co.nz/gems/latinum"
    s.platform = Gem::Platform::RUBY
    s.summary = "Latinum is a simple gem for managing resource computations, including money and minerals."
    s.files = FileList["{bin,lib,test}/**/*"] + ["README.md"]

    s.has_rdoc = "yard"
  end
end
