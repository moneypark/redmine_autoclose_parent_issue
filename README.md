# Redmine Plugin for autoclosing parent issues
This plugin automatically closes a parent issue if all of its children are closed.

## Requirements
* Ruby 2.2 or higher
* Redmine 3.4 or higher

## Installing the plugin
See [Installing a plugin](http://www.redmine.org/projects/redmine/wiki/Plugins) 
in the Redmine Wiki.

**IMPORTANT**: Install this plugin without the *redmine_* prefix, for instance with git:
`$ cd {redmine_path}/plugins && git clone 
https://github.com/moneypark/redmine_autoclose_parent_issue autoclose_parent_issue`

## Setup
Once the installation is done, go to the Redmine administration,
open the plugin page and go to the configuration page of this plugin.

### Activate the plugin
Make sure the checkbox is activated (Otherwise use this setting to disable the plugin)

### Select the targeted closed status
Since Redmine lets you create different closed statuses, you have to manually decide
which status should be applied on the parent issue, once all its child issues
are closed.

## Notes
This plugin does hook into the after-save event of an issue, so it will NOT automatically
apply this behavior to all existing issues.

After an issue is saved, the plugin checks if it has a parent issue and if so, 
it checks if all of its siblings have a closed status - in this case it will 
automatically close the parent issue without creating a journal entry.
