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
      connection.create_table(:countries, :force => true) do |t|
        t.string :name
        t.string :capital
        t.string :comment
      end
      extend ColumnHider::ActiveRecordAttributes
      column_hider_columns :capital
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
end
