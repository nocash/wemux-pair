module Wemux
  module Pair
    class PairConnection
      attr_reader :tunnel
      def initialize(tunnel)
        @tunnel = tunnel
      end

      def port_offset
        tunnel.port_offset
      end

      def client_port
        tunnel.client_port
      end

      def offset_port(port)
        port + port_offset
      end

      def port_forwards
        [
          [3000, 3000],
          [4000, 4000],
          [5000, 5000],
          [7000, 7000],
        ].map { |remote, local|
          "-L #{local}:localhost:#{remote}"
        }
      end

      def ssh_options
        [
          "StrictHostKeyChecking no",
          "UserKnownHostsFile /dev/null",
        ].map { |o| "-o \"#{o}\""}.join(" ")
      end

      def connect
        system [
          "ssh",
          ssh_options,
          port_forwards,
          "-p #{client_port}",
          "#{Wemux::Pair.config.pair_user}@localhost",
        ].join(" ")
      end
    end
  end
end
