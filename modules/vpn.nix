{config, pkgs, ...}:
{
  networking.firewall = {
    allowedUDPPorts = [ 37581 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.73.105.2/32" ];
      listenPort = 37581; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKey = "oDfsYqQoRTz9xEAGZx5qU4E+n3EH2ZK6Gp/nB4GfgVA=";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "gPwwy+XkK+28z/HiwagLLJPQ3Nf0kZlj5lf9F9EsUy4=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "78.142.61.220:37581"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  }; 
}
