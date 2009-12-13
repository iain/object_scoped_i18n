require 'i18n' unless Object.const_defined?(:I18n)

# Translate using i18n and scope accoring to the object's place in Ruby's
# hierarchial structure.
#
# To use, extend the class:
#
#   class Admin < User
#     extend ObjectScopedI18n
#   end
#
# You can now call translations on the object:
#
#   Admin.translate(:name)
#
# Which calls I18n like this:
#
#   I18n.translate(:"admin.name", :default => [:"user.name", :"object.name"])
#
# Which looks up "admin.name" first; if it didn't found that, it looks up
# "user.name", including any included modules, all way up.
#
# Namespaces are introduced as extra scope.
#
#   class SomeModule::SomeClass
#   end
#
#   SomeModule::SomeClass.translate(:name)
#
# Will be the same as:
#
#   I18n.translate(:"some_module.some_class.name", :default => {...})
#
# You can off course use all the options you would normally use with I18n.
module ObjectScopedI18n

  # Perform a basic translation, depending on the object it was called on.
  def translate(key, options = {}, &block)
    I18n.translate(*object_scoped_i18n_options(key, options.dup), &block)
  end
  alias t translate

  # Same as 'translate' but raises an exception if no translation was found.
  def translate!(key, options = {}, &block)
    I18n.translate!(*object_scoped_i18n_options(key, options.dup), &block)
  end
  alias t! translate!

  def object_scoped_i18n_options(key, options = {})
    separator = options[:separator] || I18n.default_separator
    translation_tree = self.ancestors.map do |mod|
      # Yes, this looks like the ActiveSupport#underscore method, but it's
      # a bit different. I needed to have the namespace separator after
      # the downcase method, because I don't want to downcase that.
      # Besides, now this gem doesn't have an ActiveSupport dependency.
      scope_name = mod.to_s.
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase.
      gsub(/::/, separator)
      :"#{scope_name}#{separator}#{key}"
    end
    translation_key = translation_tree.shift
    options[:default] = (options[:default] || []) + translation_tree
    [ translation_key, options ]
  end

end
