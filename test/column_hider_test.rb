require 'test_helper'

class ColumnHiderTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ColumnHider
  end
end



# require 'test/test_helper'
#
# describe ColumnHider do
#   it 'has a version number' do
#     expect(ColumnHider::VERSION).not_to be nil
#   end
#
# end
#
# describe ActiveRecord::Attributes, "active record attributes" do
#
#   before do
#     class Country < ActiveRecord::Base
#       establish_connection :adapter => "sqlite3", :database => ":memory:"
#       connection.create_table(:countries, :force => true) do |t|
#         t.string :name
#         t.string :capital
#         t.string :comment
#       end
#       extend Columns::ActiveRecordAttributes
#       removed_columns :capital
#     end
#   end
#
#   after do
#     Object.send :remove_const, :Country
#   end
#
#   describe "#columns" do
#     context 'column is removed in the model' do
#       let(:mock_col_arr) { %w(id name comment) }
#       it "shows the removed column is not present in the table" do
#         col_arr = []
#         Country.columns.each do |col|
#           col_arr << col.name
#         end
#         expect(col_arr).to eq(mock_col_arr)
#         expect(col_arr).to include('comment')
#         expect(col_arr).not_to include('capital')
#       end
#     end
#
#     context 'column is removed dynamically' do
#       let(:mock_col_arr) { %w(id name capital) }
#       before do
#         Country.send :removed_columns, :comment
#       end
#       it "shows a previously removed column can be restored, and a different column removed" do
#         col_arr = []
#         Country.columns.each do |col|
#           col_arr << col.name
#         end
#         expect(col_arr).to eq(mock_col_arr)
#         expect(col_arr).to include('capital')
#         expect(col_arr).not_to include('comment')
#       end
#     end
#   end
# end
