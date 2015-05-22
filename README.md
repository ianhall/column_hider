# ColumnHider

## Procedure for deleting or renaming database columns in Rails applications

### Avoiding downtime, or reliability issues during deploys

Ian Hall, May 2015

___

The process of deleting or renaming columns in a production database has some hidden dangers, more or less severe depending on how long it takes to run different parts of your deployment process.

This procedure aims to completely avoid these issues. If you can’t afford an deployment outage and want your application to be as close to 100% available as possible, you might like to consider this procedure.

___

## Column-deletion procedure
### Problem Definition

When a Rails model is first used in a running Rails application, all the columns in the underlying database table are enumerated. The list of columns is kept in a class instance variable of an <code>ActiveRecord::Attribute::ClassMethods</code> method named `columns`.  Once created, this variable persists for the lifetime of the running application.

Caching the column names this way is a good performance enhancement for the application, but it can lead to problems during or after database changes.

Without the procedure described below, one would run a migration to physically remove the column-to-be-deleted (`CTBD`), then deploy a new version of the application, with all references to the `CTBD` removed. After successful deployment, restart the application.

<b>The danger period is the interval between the migration completing and the application restarting.</b>

Even though this interval may be relatively short - perhaps only a minute or two - if it’s possible that the running application will access the table that you’ve changed with the migration, then you’ll run into a problem.

### Solution

The solution to this problem lies in overriding the `ActiveRecord` columns method described above.

* Step One

  Add the `column_hider` gem to your Gemfile and run `bundle install`.

  In the model for your application which contains the `CTBD`, add these two lines:

  ```ruby  
    extend ColumnHider::ActiveRecordAttributes   
    column_hider_columns :column_one
  ```   

  where `:column_one` is the `CTBD`.

  This logically deletes the column from the application - whenever the application accesses the model, the column will be removed from the list of columns that the application knows about.

  Then go through your application in the normal way and remove all other references to the `CTBD`.

* Step Two
 
  Deploy the code changes made in Step One.

  At this point, your application will know nothing about the `CTBD`.

* Step Three
 
  Create and deploy a Rails migration to physically remove the `CTBD`.

* Step Four

  Remove the two lines from your model that were added in Step One. Deploy this whenever …

* Step Five
 
  … and relax!

## Renaming columns

The simple solution to this is: don’t do it! Instead:

* create a new column with the desired name
* migrate all data from the old column to the new column
* change all references to the old column name in your code to use the new column name
* (optional) use the column-deletion procedure above to remove the old column

The second step, migrating data from old to new columns, may need to be repeated before the fourth step if there is any gap in time which allows data to be updated between steps two and three.

## Conclusion

This might seem like a long-winded way to go about it, but it will help you avoid any problems in your running application when deleting or renaming columns.

Your mileage may vary, depending on the usage pattern of your application. If you can afford to take downtime and close down user access during a deployment window, you can safely run a destructive migration followed by an application deploy.
