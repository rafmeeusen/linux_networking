# as root:
ip netns add nsraf1
ip netns add nsraf2
ip link add vethraf1_ns type veth peer name vethraf1_host
ip link add vethraf2_ns type veth peer name vethraf2_host
ip link set vethraf1_ns  netns nsraf1
ip link set vethraf2_ns  netns nsraf2

ip addr add 192.168.11.1/16 dev vethraf1_host
ip addr add 192.168.22.1/16 dev vethraf2_host

ip netns exec nsraf1 ip addr add 192.168.11.2/16 dev vethraf1_ns
ip netns exec nsraf2 ip addr add 192.168.22.2/16 dev vethraf2_ns

ip link set vethraf1_host up
ip link set vethraf2_host up

