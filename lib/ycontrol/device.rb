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

    def volumn(level, zone = 'Main_Zone')
      put(zone, 'Volumn', 'Lvl' => ['Val' => level, 'Exp' => 1, 'Unit' => 'dB'])
    end

    def party_mode(mode = 'On')
      put('System', 'Party_Mode', 'Mode' => mode)
    end

    def set_input(input, zone = 'Main_Zone')
      put(zone, 'Input', 'Input_Sel' => input)
    end

    def set_input_decoder(input, decoder, zone = 'Main_Zone')
      put(zone, 'Input', 'Decoder_Sel', input, decoder)
    end

    def pure_direct(mode = 'On')
      put('Main_Zone', 'Sound_Video', 'Pure_Direct', 'Mode' => mode)
    end

    def straight(mode = 'On', zone = 'Main_Zone')
      put(zone, 'Surround', 'Program_Sel', 'Current', 'Straight' => mode)
    end

    def enhancer(mode = 'On', zone = 'Main_Zone')
      put(zone, 'Surround', 'Program_Sel', 'Current', 'Enhancer' => mode)
    end

    def set_tuner_frequency(freq, band = 'FM', unit = 'MHz')
      put('Tuner', 'Play_Control', 'Tuning', 'Freq', band => ['Val' => freq, 'Exp' => 2, 'Unit' => unit])
    end

    def stop(input)
      put(input, 'Play_Control', 'Playback' => 'Stop')
    end

    def start(input)
      put(input, 'Play_Control', 'Playback' => 'Play')
    end

    def pause(input)
      put(input, 'Play_Control', 'Playback' => 'Pause')
    end

    def skip(input, direction)
      put(input, 'Play_Control', 'Playback' => "Skip #{direction}")
    end

    def shuffle(input, mode = 'On')
      put(input, 'Play_Control', 'Play_Mode', 'Shuffle' => mode)
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