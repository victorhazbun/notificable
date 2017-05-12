require "wisper"
module Notificable
  class Core
    include Wisper::Publisher
    attr_reader :notification

    def initialize(notification={})
      @notification = notification
    end

    def execute
      if notification.is_a?(Hash) && notification.any?
        broadcast(:successful, notification)
      else
        broadcast(:failed, notification)
      end
    end
  end
end