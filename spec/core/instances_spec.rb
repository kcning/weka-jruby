require 'spec_helper'
require 'fileutils'

describe Weka::Core::Instances do

  let(:file) { File.expand_path('../../support/resources/weather.arff', __FILE__) }
  subject { Weka::Core::Parser.parse_arff(file) }

  it { is_expected.to respond_to :each }
  it { is_expected.to respond_to :each_with_index }
  it { is_expected.to respond_to :each_attribute }
  it { is_expected.to respond_to :each_attribute_with_index }

  it { is_expected.to respond_to :to_arff }
  it { is_expected.to respond_to :to_csv }
  it { is_expected.to respond_to :to_json }

  it { is_expected.to respond_to :numeric }
  it { is_expected.to respond_to :nominal }
  it { is_expected.to respond_to :string }
  it { is_expected.to respond_to :date }

  describe 'aliases' do
    let (:instances) { described_class.new }

    {
      numeric: :add_numeric_attribute,
      string:  :add_string_attribute,
      nominal: :add_nominal_attribute,
      date:    :add_date_attribute
     }.each do |method, alias_method|
      it "defines the alias ##{alias_method} for ##{method}" do
        expect(instances.method(method)).to eq instances.method(alias_method)
      end
     end
  end

  describe 'converter' do
    before(:all) { @tmp_dir = File.expand_path('../../tmp/', __FILE__) }

    after :all do
      FileUtils.remove_dir(@tmp_dir, true)
    end

    [:arff, :csv, :json].each do |type|
      describe "#to_#{type}" do
        it "should save a test.#{type} file" do
          test_file = "#{@tmp_dir}/test.#{type}"
          expect(File.exists?(test_file)).to be false
          subject.send("to_#{type}", test_file)
          expect(File.exists?(test_file)).to be true
        end
      end
    end

  end

  describe 'attribute definers:' do
    let(:instances) { described_class.new }

    describe '#numeric' do
      it 'can be used to add a numeric attribute' do
        instances.numeric('attribute_name')
        expect(instances.attributes.first).to be_numeric
      end
    end

    describe '#string' do
      it 'can be used to add a string attribute' do
        instances.string('attribute_name')
        expect(instances.attributes.first).to be_string
      end
    end

    describe '#nominal' do
      it 'can be used to add a nominal attribute' do
        instances.nominal('attribute_name', ['yes', 'no'])
        expect(instances.attributes.first).to be_nominal
      end
    end

    describe '#date' do
      it 'can be used to add a date attribute' do
        instances.date('attribute_name')
        expect(instances.attributes.first).to be_date
      end
    end
  end

  describe '#add_attributes' do
    it 'should add the numbers of attributes given in the block' do
      instances = Weka::Core::Instances.new

      expect {
        instances.add_attributes do
          numeric 'attribute'
          nominal 'class', ['YES', 'NO']
        end
      }.to change { instances.attributes.count }.from(0).to(2)
    end

    it 'should add the types of attributes given in the block' do
      instances = Weka::Core::Instances.new

      instances.add_attributes do
        numeric 'attribute'
        nominal 'class', ['YES', 'NO']
      end

      expect(instances.attributes.map(&:name)).to eq ['attribute', 'class']
    end
  end

  describe '#initialize' do
    it 'should take an optional block' do
      expect {
        Weka::Core::Instances.new_with_attributes do
          numeric 'attribute 1'
          nominal 'class', 'YES'
        end
      }.not_to raise_error
    end
  end

end