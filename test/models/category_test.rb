require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    create_categories
  end

  teardown do
    DatabaseCleaner.clean
  end

  test 'create category happy' do
    cat = Category.new(name: 'one', key: 'one', active: false, type: 'CATEGORY')
    assert cat.validate!
  end

  test 'create bad category type fails' do
    cat = Category.new(name: 'one', key: 'one', active: false, type: 'ABC123')

    err = assert_raises ActiveModel::ValidationError do
      assert cat.validate!
    end
    assert_equal 'Validation failed: Type ABC123 is not a valid type', err.message
  end

  test 'create bad category type empty' do
    cat = Category.new(name: 'one', key: 'one', active: false, type: nil)

    err = assert_raises ActiveModel::ValidationError do
      assert cat.validate!
    end
    assert_equal "Validation failed: Type can't be blank, Type  is not a valid type", err.message
  end

  test 'create bad category no name' do
    cat = Category.new(key: 'one', active: false, type: 'CATEGORY')

    err = assert_raises ActiveModel::ValidationError do
      assert cat.validate!
    end
    assert_equal "Validation failed: Name can't be blank", err.message
  end

  test 'create bad category no key' do
    cat = Category.new(name: 'one', active: false, type: 'CATEGORY')

    err = assert_raises ActiveModel::ValidationError do
      assert cat.validate!
    end
    assert_equal "Validation failed: Key can't be blank", err.message
  end

  test 'create bad category dup key' do
    cat = Category.new(name: 'one', key: 'it', active: false, type: 'CATEGORY')

    err = assert_raises ActiveModel::ValidationError do
      assert cat.validate!
    end
    assert_equal 'Validation failed: Key is already taken', err.message
  end
end
