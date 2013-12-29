module YControl
  class Device

    attr_accessor :host

    def initialize(host)
      @host = host
    end

    def power_standby
      put('System', 'Power_Control', 'Power' => 'Standby')
    end

    def power_on
      put('System', 'Power_Control', 'Power' => 'On')
    end

    def set_volumn(level, zone = 'Main_Zone')
      put(zone, 'Volumn', 'Lvl' => ['Val' => level, 'Exp' => 1, 'Unit' => 'dB'])
    end
      
    private
      def put(*nodes)
        xml = create_xml('PUT', *nodes)
        send_request(xml)
      end

      def get(*nodes)
        xml = create_xml('GET', *nodes)
        send_request(xml)
      end

      def send_request(xml)
        begin
          response = HTTParty.post("http://#{host}/YamahaRemoteControl/ctrl", body: xml, headers: {'Content-Type' => 'text/xml'})
          return true if response.code == 200
          return false
        rescue SocketError
          return false
        end
      end

      def create_xml(cmd, *nodes)
        doc = XML::Document.new
        root = XML::Node.new('YAMAHA_AV')
        doc.root = root
        XML::Attr.new(root, 'cmd', cmd)
        last_node = root
        nodes.each do |node|
          if node.is_a?(Hash)
            node.select do |k,v|
              last_node = last_node.last if last_node.last?
              if v.is_a?(Array)
                last_node << XML::Node.new(k.to_s)
                last_node = last_node.last
                v.first.select do |k2, v2|
                  last_node << XML::Node.new(k2, v2)
                end
              else
                last_node << XML::Node.new(k, v)
              end
            end
          else
            last_node = last_node.last if last_node.last?
            last_node << XML::Node.new(node)      
          end
        end
        doc
      end
  end
end