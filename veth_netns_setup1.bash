# as root:
ip netns add nsraf1
ip netns add nsraf2
ip link add vethraf1_ns type veth peer name vethraf1_host
ip link add vethraf2_ns type veth peer name vethraf2_host
ip link set vethraf1_ns  netns nsraf1
ip link set vethraf2_ns  netns nsraf2

# masks always confusing me, but 8 means 8 network bits and 24 host bits! I want opposite here
MSK=24

# 'host' side:
ip addr add 192.168.11.1/$MSK dev vethraf1_host
ip addr add 192.168.22.1/$MSK dev vethraf2_host
ip link set vethraf1_host up
ip link set vethraf2_host up

# 'namespaces' side:
# note: lo in netns is down; if not bringing up, cannot ping to own IP ip address in netns which is confusing, so let's bring up too
ip netns exec nsraf1 ip addr add 192.168.11.2/$MSK dev vethraf1_ns
ip netns exec nsraf1 ip link set lo up
ip netns exec nsraf1 ip link set vethraf1_ns up
ip netns exec nsraf1 ip route add default via 192.168.11.1

ip netns exec nsraf2 ip addr add 192.168.22.2/$MSK dev vethraf2_ns
ip netns exec nsraf2 ip link set lo up
ip netns exec nsraf2 ip link set vethraf2_ns up
ip netns exec nsraf2 ip route add default via 192.168.22.2


# to start bash shell "in" netns nsraf1, as user USER
# ip netns exec nsraf1 bash
# followed by: su USER, and maybe export PS1="\u@\h \w nsraf1 $ "

