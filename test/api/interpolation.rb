module Tests
  module Backend
    module Api
      module Interpolation
        def interpolate(options)
          I18n.backend.translate('en', nil, options)
        end
      
        def test_interpolation_given_no_interpolation_values_it_does_not_alter_the_string
          assert_equal 'Hi {{name}}!', interpolate(:default => 'Hi {{name}}!')
        end

        def test_interpolation_given_interpolation_values_it_interpolates_the_values_to_the_string
          assert_equal 'Hi David!', interpolate(:default => 'Hi {{name}}!', :name => 'David')
        end

        def test_interpolation_given_interpolation_values_with_nil_values_it_interpolates_the_values_to_the_string
          assert_equal 'Hi !', interpolate(:default => 'Hi {{name}}!', :name => nil)
        end

        def test_interpolate_with_ruby_1_9_syntax
          assert_equal 'Hi David!', interpolate(:default => 'Hi %{name}!', :name => 'David')
        end

        def test_interpolate_given_a_value_hash_interpolates_into_unicode_string
          assert_equal 'Häi David!', interpolate(:default => 'Häi {{name}}!', :name => 'David')
        end

        def test_interpolate_given_a_unicode_value_hash_interpolates_to_the_string
          assert_equal 'Hi ゆきひろ!', interpolate(:default => 'Hi {{name}}!', :name => 'ゆきひろ')
        end

        def test_interpolate_given_a_unicode_value_hash_interpolates_into_unicode_string
          assert_equal 'こんにちは、ゆきひろさん!', interpolate(:default => 'こんにちは、{{name}}さん!', :name => 'ゆきひろ')
        end

        if Kernel.const_defined?(:Encoding)
          def test_interpolate_given_a_non_unicode_multibyte_value_hash_interpolates_into_a_string_with_the_same_encoding
            assert_equal euc_jp('Hi ゆきひろ!'), interpolate(:default => 'Hi {{name}}!', :name => euc_jp('ゆきひろ'))
          end

          def test_interpolate_given_a_unicode_value_hash_into_a_non_unicode_multibyte_string_raises_encoding_compatibility_error
            assert_raises(Encoding::CompatibilityError) do
              interpolate(:default => euc_jp('こんにちは、{{name}}さん!'), :name => 'ゆきひろ')
            end
          end

          def test_interpolate_given_a_non_unicode_multibyte_value_hash_into_an_unicode_string_raises_encoding_compatibility_error
            assert_raises(Encoding::CompatibilityError) do
              interpolate(:default => 'こんにちは、{{name}}さん!', :name => euc_jp('ゆきひろ'))
            end
          end
        end

        def test_interpolate_given_a_string_containing_a_reserved_key_raises_reserved_interpolation_key
          assert_raises(I18n::ReservedInterpolationKey) { interpolate(:default => '{{default}}',   :foo => :bar) }
          assert_raises(I18n::ReservedInterpolationKey) { interpolate(:default => '{{scope}}',     :foo => :bar) }
          assert_raises(I18n::ReservedInterpolationKey) { interpolate(:default => '{{separator}}', :foo => :bar) }
        end
      end
    end
  end
end