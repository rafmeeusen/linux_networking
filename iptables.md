## netfilter/iptables

Intro:
Quite complex.
Man-page is good, but hard to read without any context or examples.
Need to understand the concepts first.
There are a few very important sentences in the manpages that must not be overlooked.

Some concepts:
- tables, which contains chains
- chains, which contain rules
- rules, which can match or not match a packet
- targets, the 'action' to take on a packet for a matching rule

Two most important tables:
- filter table (aka default table): for stopping packets (typically: filter away, i.e. firewall behavior)
- nat table: only consulted for packets that create a new connection (typically: NAT)

Understanding the chains:
- need to understand INPUT/OUTPUT/FORWARD (aka built-in chains)
- good picture about built-in chains: packet flow figure on https://en.wikipedia.org/wiki/Netfilter
- in this picture: the lower part (Link Layer) is only applicable for Linux bridges (typically: virtual ethernet switches); for simple setups without bridge, ignore this part
- INPUT should be seen as input to the local processes (and not as input to an interface or so); similar for OUTPUT
- it's called chain, because if there is no match for a packet, the next rule in the chain is evaluated
- user defined chains can be added, but they don't have this fixed location in the packet flow like input/output/forward, they are rather like functions that can be called from another rule


