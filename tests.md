Called tests, but consider as execercises/examples for learning.

Test 1: pinging in setup 1
- basic setup1 (veth_netns_setup1.bash)
- try to ping all interfaces from all namepaces
- they are all working!
- this means that testbox "x" must be routing

Test 2: stop FORWARD in setup 1 router box
- starting from fresh test setup 1
- check iptables (iptables -L; iptables -t nat -L) in all three namespaces: all policies are ACCEPT, there are no rules at all
- let's change FORWARD policy in test_x to DROP: $ iptables -P FORWARD DROP;
- result: test_1 cannot ping test_2 anymore (and vice versa), but all other pings are still working!
- the means that testbox "x" is not routing anymore; this also means that pinging the gateway is not passing the forward chain

Test 3: stop INPUT/OUTPUT in setup 1 router box
- starting from fresh test setup 1
- in test box test_x:
- $ iptables -P INPUT DROP
- $ iptables -P OUTPUT DROP
- check again pinging behaviour: the gateway (.1) addresses cannot be pinged anymore, not even from test_x box itself!


