# run/source as root
# setup sequence for following setup
# using network-namespaces / virtual ethernet devices
# (thank you http://asciiflow.com/)
#    +-----------------+                       +-----------------+
#    |     test_1      |                       |     test_2      |
#    |                 |                       |                 |
#    |  192.168.11.2   |                       |  192.168.22.2   |
#    |     veth1x      |                       |     veth2x      |
#    +--------+--------+                       +--------+--------+
#             |                                         |
#             |                                         |
#             |                                         |
#             |                                         |
#             |  +-----------------------------------+  |
#             |  |              test_x               |  |
#             |  |                                   |  |
#             +--+ vethx1                     vethx2 +--+
#                | 192.168.11.1         192.168.22.2 |
#                |                                   |
#                +-----------------------------------+
#

# create network namespaces
for NETNS in netns_t1 netns_t2 netns_tx; do
    ip netns add $NETNS
done

# create virtual ethernet links between the namespaces
ip link add veth_test1x type veth peer name veth_testx1
ip link add veth_test2x type veth peer name veth_testx2
ip link set veth_test1x netns netns_t1
ip link set veth_test2x netns netns_t2
ip link set veth_testx1 netns netns_tx
ip link set veth_testx2 netns netns_tx

# assign IP addresses to all ethernet interfaces
MSK=24
NET1=192.168.11
NET2=192.168.22
GW1=$NET1.1
GW2=$NET2.1
# around veth 1x-x1:
ip netns exec netns_tx ip addr add $GW1/$MSK dev veth_testx1
ip netns exec netns_t1 ip addr add $NET1.2/$MSK dev veth_test1x
# around veth 2x-x2:
ip netns exec netns_tx ip addr add $GW2/$MSK dev veth_testx2
ip netns exec netns_t2 ip addr add $NET2.2/$MSK dev veth_test2x

# bring all if up, including lo
ip netns exec netns_t1 ip link set lo up
ip netns exec netns_t1 ip link set veth_test1x up
ip netns exec netns_t2 ip link set lo up
ip netns exec netns_t2 ip link set veth_test2x up
ip netns exec netns_tx ip link set lo up
ip netns exec netns_tx ip link set veth_testx1 up
ip netns exec netns_tx ip link set veth_testx2 up

# set default gateways for t1 and t2
ip netns exec netns_t1 ip route add default via $GW1
ip netns exec netns_t2 ip route add default via $GW2

echo To start bash shell "in" netns, as user USER, with prompt indicating the network namespace:
echo ip netns exec netns_t1 bash
echo su USER
echo export PS1=\"\\u@\\h \\w netns_t1 $ \"

