require 'redmine'

# Redmine Google Calendar plugin
Redmine::Plugin.register :redmine_google_calendar do
  name 'Google Calendar Plugin'
  author 'Pablo Moreira Mora'
  description 'A plugin to allow users to add a new tab with an embedded Google Calendar Iframe.'
  version '0.2.0'
  
  # This plugin contains settings
  settings :default => {
    'iframe_text' => ''
  }, :partial => 'settings/googlecalendar_settings'
  
  # This plugin adds a project module
  # It can be enabled/disabled at project level (Project settings -> Modules)
  project_module :google_calendar do
    # This permission has to be explicitly given
    # It will be listed on the permissions screen
    permission :view_google_calendar_tab, {:google_calendar => :show}
  end
  
  # A new item is added to the project menu
  menu :project_menu, :google_calendar, { :controller => 'google_calendar', :action => 'show' }
end