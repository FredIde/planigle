# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups; set the level to warning
# config.logger = SyslogLogger.new
config.log_level = :warn # In some environments, logger not present yet.  This will configure it work when created.
RAILS_DEFAULT_LOGGER.level = Logger::WARN if defined? RAILS_DEFAULT_LOGGER

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :smtp

# Set notification
PLANIGLE_EMAIL_NOTIFIER = Notification::EmailNotifier.new
PLANIGLE_SMS_NOTIFIER = Notification::Notifier.new
