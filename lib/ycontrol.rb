require 'ycontrol/device'

module YControl

  class << self
    def device
      @device = YControl::Device.new
      @device
    end

    def respond_to_missing?(method_name, include_private=false); device.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); device.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

    private

    def method_missing(method_name, *args, &block)
      return super unless device.respond_to?(method_name)
      device.send(method_name, *args, &block)
    end
  end

end