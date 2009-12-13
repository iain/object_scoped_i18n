$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'object_scoped_i18n'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

I18n.load_path << File.dirname(__FILE__) + '/locale.yml'

module Scoped
  module IncludedModule
  end
  class SuperClass
  end
  class SomeClass < SuperClass
    extend ObjectScopedI18n
    include IncludedModule
  end
end

class Animal
  extend ObjectScopedI18n
end

class Monkey < Animal

end
