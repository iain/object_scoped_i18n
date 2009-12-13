require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ObjectScopedI18n" do

  describe "#translate" do

    it "should send a i18n call" do
      I18n.should_receive(:translate).with(:foo, :bar)
      Monkey.should_receive(:object_scoped_i18n_options).with(:some_method, {}).and_return([:foo, :bar])
      Monkey.translate(:some_method)
    end

    it "should alias to 't'" do
      I18n.should_receive(:translate).with(:foo, :bar)
      Monkey.should_receive(:object_scoped_i18n_options).with(:some_method, {}).and_return([:foo, :bar])
      Monkey.t(:some_method)
    end

  end

  describe "#translate!" do

    it "should send a i18n call" do
      I18n.should_receive(:translate!).with(:foo, :bar)
      Monkey.should_receive(:object_scoped_i18n_options).with(:some_method, {}).and_return([:foo, :bar])
      Monkey.translate!(:some_method)
    end

    it "should alias to 't!'" do
      I18n.should_receive(:translate!).with(:foo, :bar)
      Monkey.should_receive(:object_scoped_i18n_options).with(:some_method, {}).and_return([:foo, :bar])
      Monkey.t!(:some_method)
    end

  end

  describe "#object_scoped_i18n_options" do

    it "should scope properly" do # Look at locale.yml to see what happened
      Monkey.t!(:something, :scope => "translation_scope")
    end

    it "should translate scoped" do
      subject = Scoped::SomeClass.object_scoped_i18n_options(:my_method)
      subject[0].should == :"scoped.some_class.my_method"
    end

    it "should know an included module" do
      subject = Scoped::SomeClass.object_scoped_i18n_options(:my_method)
      subject[1][:default][0].should == :"scoped.included_module.my_method"
    end

    it "should know super class" do
      subject = Scoped::SomeClass.object_scoped_i18n_options(:my_method)
      subject[1][:default][1].should == :"scoped.super_class.my_method"
    end

    it "should override separator" do
      subject = Monkey.object_scoped_i18n_options(:my_method, :separator => "X")
      subject[0].should == :"monkeyXmy_method"
    end

    it "should use I18n's default separator" do
      old_separator, I18n.default_separator = I18n.default_separator, "Y"
      subject = Monkey.object_scoped_i18n_options(:my_method)
      subject[0].should == :"monkeyYmy_method"
      I18n.default_separator = old_separator
    end

    it "should leave other options untouched" do
      subject = Monkey.object_scoped_i18n_options(:my_method, :my_options => "x")
      subject[1][:my_options].should == "x"
    end

  end

end
