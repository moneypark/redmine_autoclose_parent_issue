require 'redmine'

# Get ready for Rails 5.1
if Rails::VERSION::MAJOR >= 5 && Rails::VERSION::MINOR >= 1
  reloader = ActiveSupport::Reloader
else
  reloader = ActionDispatch::Callbacks
end

# Ensure Patches are applied
reloader.to_prepare do
  require_dependency 'issue'
  require_dependency 'autoclose_parent_issue/issue_patch'

  unless Issue.included_modules.include? AutocloseParentIssue::IssuePatch
    Issue.send :include, AutocloseParentIssue::IssuePatch
  end
end

Redmine::Plugin.register :autoclose_parent_issue do
  name 'Autoclose parent Issue Plugin for Redmine'
  author 'MoneyPark AG'
  description 'Closes a parent Issue if all of its child Issues are closed'
  version '0.1.0'
  url 'https://github.com/moneypark/redmine_autoclose_parent_issue'
  author_url 'https://github.com/moneypark/'
  requires_redmine version_or_higher: '3.4'

  settings(
      default: {
          active: true,
          closed_status_id: (IssueStatus.where(is_closed: true).first.id rescue ActiveRecord::RecordNotFound 0)
      },
      partial: 'settings/autoclose_settings'
  )
end
