require 'spec_helper'
using Weka::Refinement

describe Array do
  let(:instances)       { load_instances('weather.arff') }
  let(:correct_indices) { [*0...5].permutation.to_a.sample }
  let(:attributes)      { %w(outlook temperature humidity windy play) }

  describe '#instances_indices' do
    context 'when self is an array of Strings' do
      let(:permutated_attributes) { correct_indices.map { |i| attributes[i] } }

      it 'returns the correct indices' do
        expect(permutated_attributes
          .instances_indices(instances)).to eq correct_indices
      end

      it 'returns -1 for non-existent attributes' do
        expect(['non_existent'].instances_indices(instances)).to eq [-1]
      end
    end

    context 'when self is an array of Symbols' do
      let(:permutated_attributes) do
        correct_indices.map { |i| attributes[i].to_sym }
      end

      it 'returns the correct indices' do
        expect(permutated_attributes
          .instances_indices(instances)).to eq correct_indices
      end

      it 'returns -1 for non-existent attributes' do
        expect([:non_existent].instances_indices(instances)).to eq [-1]
      end
    end

    context 'when self contains elements of other types' do
      let(:invalid_array) { ['attribute1', 10] }

      it 'raises an error' do
        expect do
          invalid_array.instances_indices(instances)
        end.to raise_error RuntimeError
      end
    end
  end
end
