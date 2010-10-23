require 'redmine'

require 'estimate_patch'

require 'dispatcher'
Dispatcher.to_prepare do
  Issue.send(:include, Estimate::IssuePatch)
end


Redmine::Plugin.register :redmine_framework do
  name 'Redmine framework'
  url 'http://redmine.org'
  author 'Michael Schiller'
  author_url ''
              
  description ''
  version '0.1.0'
  requires_redmine :version_or_higher => '0.8.0'
end
