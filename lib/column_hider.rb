require "column_hider/version"

module ColumnHider
  #
  # Overrides the Rails ActiveRecord Attributes "columns" method.
  # This allows the logical removal of a column prior to its physical removal.
  # To use, add two lines to your model:
  # `  extend Columns::ActiveRecordAttributes`
  # `  hidden_columns :column_one, :column_two, ...`
  #

  module ActiveRecordAttributes

    def hidden_columns(*cols)
      @hidden_columns = []
      cols.each do |col|
        @hidden_columns << col.to_s
      end
    end

    def columns
      @hidden_columns ||= [] # just in case the model includes the line "  extend Columns::ActiveRecordAttributes", but doesn't call hidden_columns
      super.reject { |col| @hidden_columns.include?(col.name) }
    end
  end
end
