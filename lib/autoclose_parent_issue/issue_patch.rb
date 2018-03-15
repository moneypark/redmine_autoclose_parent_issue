# Contains the logic needed to close the parent issue if all siblings are closed
module AutocloseParentIssue

  # Issue model extensions
  module IssuePatch

    # On inclusion in a class/module
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        # Add an after save event listener
        after_save :autoclose_parent_issue
      end
    end

    # These methods will be injected into the Issue model
    module InstanceMethods

      # Get the ID of the status which will be treated as the Close status for the parent issue
      #
      # @return [IssueStatus] If the plugin is not active or there is no valid ID: nil; otherwise the closed status
      def get_closed_status
        return nil unless Setting.respond_to? :plugin_autoclose_parent_issue
        settings = Setting.plugin_autoclose_parent_issue
        return nil unless settings.key?('active') and settings['active']
        return nil unless settings.key?('closed_status_id') and settings['closed_status_id'].to_i >= 0
        begin
          IssueStatus.find settings['closed_status_id'].to_i
        rescue ActiveRecord::RecordNotFound
          nil
        end
      end

      # Switches the issue status to closed
      #
      # @return [nil]
      def close
        closed_status = get_closed_status
        return if closed_status.nil?
        self.status = closed_status
        result = self.save

      end

      # Closes the parent issue if all siblings have a closed status
      #
      # @return [nil]
      def autoclose_parent_issue
        parent.close! if parent and parent.children.all?(&:closed?)
      end
    end
  end
end
