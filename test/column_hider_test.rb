require 'minitest/autorun'
require 'minitest/spec'
require 'test_helper'

describe ColumnHider do
  it 'has a version number' do
    expect(ColumnHider::VERSION).wont_be_nil
  end

  before do
    class Country < ActiveRecord::Base
      establish_connection :adapter => 'sqlite3', :database => ':memory:'
      connection.create_table(:countries) do |t|
        t.string :name
        t.string :capital
        t.string :comment
      end
      extend ColumnHider::ActiveRecordAttributes
      column_hider_columns :capital
      column_hider_deprecate_columns :capital
    end
  end

  after do
    Object.send :remove_const, :Country
  end

  describe '#column is removed in the model' do
    let(:mock_col_arr) { %w(id name comment) }
    col_arr = []

    it '#shows the column is not there' do
      Country.columns.each do |col|
        col_arr << col.name
      end
      expect(col_arr).must_equal(mock_col_arr)
      expect(col_arr).must_include('comment')
      expect(col_arr).wont_include('capital')
    end

    it '#raises an error if we reference a hidden column via mass assignment' do
      assert_raises NoMethodError do
        c = Country.new(name: 'USA', capital: 'Washington, DC', comment: 'America')
      end
    end

    it '#raises an error if we reference a hidden column via individual assignment' do
      assert_raises NoMethodError do
        c = Country.new
        c.capital = 'Edinburgh'
      end
    end
  end

  describe '#column is removed dynamically' do
    let(:mock_col_arr) { %w(id name capital) }
    col_arr = []

    it '#shows the column is not there' do
      Country.send :column_hider_columns, :comment
      Country.columns.each do |col|
        col_arr << col.name
      end
      expect(col_arr).must_equal(mock_col_arr)
      expect(col_arr).must_include('capital')
      expect(col_arr).wont_include('comment')
    end
  end

  describe '#multiple columns are removed dynamically' do
    let(:mock_col_arr) { %w(id name) }
    col_arr = []

    it '#shows the column is not there' do
      Country.send :column_hider_columns, :comment, :capital
      Country.columns.each do |col|
        col_arr << col.name
      end
      expect(col_arr).must_equal(mock_col_arr)
      expect(col_arr).wont_include('capital')
      expect(col_arr).wont_include('comment')
    end
  end

  describe '#no columns are removed' do
    let(:mock_col_arr) { %w(id name capital comment) }
    col_arr = []

    it '#shows the column is not there' do
      Country.send :column_hider_columns
      Country.columns.each do |col|
        col_arr << col.name
      end
      expect(col_arr).must_equal(mock_col_arr)
      expect(col_arr).must_include('capital')
      expect(col_arr).must_include('comment')
    end
  end
end
