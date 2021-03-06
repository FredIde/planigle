class Notification::Notifier
  # Notify address that message has been sent.
  def send_notification(project, address, subject, message)
    log = Logger.new(STDOUT)
    log.info("Sending '" + message.to_s + "' to " + address.to_s)
  end
end