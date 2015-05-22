require "column_hider/version"

module ColumnHider
  #
  # Overrides the Rails ActiveRecord Attributes "columns" method.
  # This allows the logical removal of a column prior to its physical removal.
  # To use, add two lines to your model:
  # `  extend ColumnHider`
  # `  column_hider_columns :column_one, :column_two, ...`
  #
  module ActiveRecordAttributes
    def column_hider_columns(*cols)
      @column_hider_columns = []
      cols.each do |col|
        @column_hider_columns << col.to_s
      end
    end

    def columns
      @column_hider_columns ||= [] # just in case the model includes the line "  extend ColumnHider", but doesn't call column_hider_columns
      super.reject { |col| @column_hider_columns.include?(col.name) }
    end
  end

end
