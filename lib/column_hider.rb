require "column_hider/version"

module ColumnHider
  #
  # Overrides the Rails ActiveRecord Attributes "columns" method.
  # This allows the logical removal of a column prior to its physical removal.
  # To use, add two lines to your model:
  # `  extend ColumnHider::ActiveRecordAttributes`
  # `  column_hider_columns :column_one, :column_two, ...`
  # If you want to deprecate the columns, call:
  # `  column_hider_deprecate_columns :column_one, :column_two, ...`
  #    This will also hide the columns
  #
  module ActiveRecordAttributes
    def column_hider_columns(*cols)
      @column_hider_columns = {}
      cols.each do |col|
        @column_hider_columns[col] = true
      end
    end

    def columns
      @column_hider_columns ||= {} # just in case the model has "extend ColumnHider::ActiveRecordAttributes", but doesn't call column_hider_columns
      super.reject { |col| @column_hider_columns.has_key?(col.name.to_sym) }
    end

    def column_hider_deprecate_columns(*cols)
      cols.each do |c|
        define_method("#{c}".to_sym) do
          raise NoMethodError.new("column '#{c}' deprecated", c.to_sym)
        end
        define_method("#{c}=".to_sym) do |arg|
          raise NoMethodError.new("column '#{c}' deprecated", c.to_sym)
        end
      end
      column_hider_columns(*cols)
    end

  end

end
