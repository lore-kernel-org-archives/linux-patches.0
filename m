Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042762;
	b=Qid/xtX0+tQ6Sd4Y9tnT8KqKbx3oZNjBS6v3dKOXGb52Prxiw8gGuGCBZXZ6uuJ5g4qh
	 9AHxvtrEWxhMy5h/yWt/2gt0cJeiiJ67O566ozPl2AQqGe5B4vLxcLmPmmjjb7beK3HWQ
	 KkDJl9hYLlM2/48ZHuR76t1YghL978QalA0FSkX9k3dqppGhUGpjqw3RhB9yP1j7f46aU
	 33cx9hYhJl12v4mi9WF281bmSee7BeF8CXCpnp0r6IhYTcQkjv2rPyQjCVEOaCtyAf8Sc
	 KrkacQKzA1hJ0lbuI7GTyH8H/6JZR40gWMbJ0rBMX3Dm8JKJgwuZIgEzrmWe+d14tvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQ9Eh3NGzYZ1xT6aIuq9UcgrWY0/BqQSyS3W1YrTE1M=;
	b=sZ6qcs6pj9Ia5l+daPxHao6r111uJ3hDB52FDQzuZZcOQHNAU0VKFZG8QwW8q7TYovv5
	 spUBisJkrB3m98NjZ9JHdSjKx+JqmufYCw/UN35IhciOSRtWm5Z9BAJrNMdzEftHF60Ft
	 dYEBiUF5QdqZNysE+MFBeIy3hmX28TYU2xG0T0DUsH20h1JqAxmtAYyYrZF6G5rUoR0Cw
	 690+ox5XC+bpsipRr/4M2+OolEIsNEsICrSBUQqY7CF3gya/Pfk+Q+zJ+pnX4TIx9WuZr
	 qobJh/a0Pep0oGKLlxfHGixvnvOdf3PeuaDIbXPzS/XtPuPoztPZKwOLkrV34gmr6xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZmKalUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0C5606A31C;
	Wed, 18 Nov 2026 22:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZmKalUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FE71F000C4;
	Wed, 18 Nov 2026 22:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042762;
	bh=AQ9Eh3NGzYZ1xT6aIuq9UcgrWY0/BqQSyS3W1YrTE1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZmKalUhhfPWRztuAxSKiixzuIuenxA5SieaXoPfl6A/CxVmdmU2Q/8846em0UEdz
	 ZUvCTeD3yu1Ade8TJD2gQFiF/Sn2UNkY3qv4+8khElhwptZacsH8H4q8ICbRCZjeq1
	 Ii/tYJpfz8GCcBMRF9LDJekr38wHeTrzC7CR+cIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3284/3318] net: use eth_type_trans_careful() in __dev_forward_skb2()
Date: Wed, 18 Nov 2026 16:05:06 +0100
Message-ID: <20261118150458.127753148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 695e1408eb908ac7acf78069933201f92b95727c ]

A tc egress BPF program can push a tiny link-layer header with
bpf_skb_change_head() on an skb whose head is almost empty, then
redirect it to an Ethernet device ingress. __bpf_redirect_common()
only checks mac_header < network_header, and __dev_forward_skb2()
crashes in eth_type_trans():

  tc filter add dev lo egress pref 1 matchall action vlan pop_eth continue
  tc filter add dev lo egress pref 2 bpf da obj prog.o
  # prog: bpf_skb_change_head(skb, 1, 0);
  #       return bpf_redirect(veth1_ifindex, BPF_F_INGRESS);
  # AF_PACKET SOCK_RAW on lo: eth / eth / 8192 bytes of payload

  kernel BUG at include/linux/skbuff.h:2839!
  RIP: 0010:eth_type_trans (include/linux/etherdevice.h:635 net/ethernet/eth.c:163)
  Call Trace:
   __dev_forward_skb2 (net/core/dev.c:2507)
   dev_forward_skb_nomtu (net/core/dev.c:2546)
   __dev_queue_xmit (net/core/dev.c:4738 net/core/dev.c:4998)
   packet_sendmsg (net/packet/af_packet.c:3157 net/packet/af_packet.c:3189)

Use eth_type_trans_careful(), and drop the packet if the Ethernet
header can not be pulled. This also covers other dev_forward_skb()
users (veth, macvlan, ipvlan, netdevsim, l2tp_eth).

Update the empty_skb BPF selftest: at lwt_xmit, BPF_PROG_TEST_RUN
strips the Ethernet header, so the "veth ETH_HLEN+1" packet is a 1-byte
skb. Redirecting it to veth ingress used to read the Ethernet header
past skb->tail and deliver a 1-byte frame; it is now dropped with
NET_RX_DROP, as veth_xmit() already does at egress.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028122703.2093730-4-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c                                | 18 +++++++++++++-----
 .../selftests/bpf/prog_tests/empty_skb.c      | 19 ++++++++++++-------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a270657f672fb..95beb4b402d0c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2227,14 +2227,22 @@ EXPORT_SYMBOL_GPL(is_skb_forwardable);
 static int __dev_forward_skb2(struct net_device *dev, struct sk_buff *skb,
 			      bool check_mtu)
 {
-	int ret = ____dev_forward_skb(dev, skb, check_mtu);
+	enum skb_drop_reason reason;
+	int ret;
+
+	ret = ____dev_forward_skb(dev, skb, check_mtu);
+	if (unlikely(ret))
+		return ret;
 
-	if (likely(!ret)) {
-		skb->protocol = eth_type_trans(skb, dev);
-		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
+	reason = eth_type_trans_careful(skb, dev);
+	if (unlikely(reason)) {
+		dev_core_stats_rx_dropped_inc(dev);
+		kfree_skb_reason(skb, reason);
+		return NET_RX_DROP;
 	}
+	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
 
-	return ret;
+	return 0;
 }
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
index 20ea2f9143917..e7da83fddfe55 100644
--- a/tools/testing/selftests/bpf/prog_tests/empty_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -24,7 +24,7 @@ void test_empty_skb(void)
 		int *ifindex;
 		int err;
 		int ret;
-		int lwt_egress_ret; /* expected retval at lwt/egress */
+		int lwt_ret; /* expected retval at lwt */
 		__be16 h_proto;
 		bool success_on_tc;
 		bool adjust_room;
@@ -82,7 +82,7 @@ void test_empty_skb(void)
 			.data_size_in = sizeof(eth_hlen),
 			.ifindex = &veth_ifindex,
 			.ret = -ERANGE,
-			.lwt_egress_ret = -ERANGE,
+			.lwt_ret = -ERANGE,
 			.success_on_tc = true,
 		},
 		{
@@ -96,17 +96,23 @@ void test_empty_skb(void)
 			.data_size_in = sizeof(eth_hlen),
 			.ifindex = &ipip_ifindex,
 			.ret = -ERANGE,
-			.lwt_egress_ret = -ERANGE,
+			.lwt_ret = -ERANGE,
 		},
 
-		/* ETH_HLEN+1-sized packet should be redirected. */
+		/* ETH_HLEN+1-sized packet should be redirected at TC.
+		 * At LWT, the Ethernet header is not part of the skb, and
+		 * a 1-byte packet is too short for an Ethernet device.
+		 */
 
 		{
 			.msg = "veth ETH_HLEN+1 packet ingress",
 			.data_in = eth_hlen_pp,
 			.data_size_in = sizeof(eth_hlen_pp),
 			.ifindex = &veth_ifindex,
-			.lwt_egress_ret = 1, /* veth_xmit NET_XMIT_DROP */
+			/* lwt: skb->len=1, dropped by veth_xmit() at egress
+			 * and by __dev_forward_skb2() at ingress.
+			 */
+			.lwt_ret = 1, /* NET_XMIT_DROP / NET_RX_DROP */
 		},
 		{
 			.msg = "ipip ETH_HLEN+1 packet ingress",
@@ -142,7 +148,6 @@ void test_empty_skb(void)
 			eth_hlen.h_proto = tests[i].h_proto;
 
 		bpf_object__for_each_program(prog, bpf_obj->obj) {
-			bool at_egress = strstr(bpf_program__name(prog), "egress") != NULL;
 			bool at_tc = !strncmp(bpf_program__section_name(prog), "tc", 2);
 			bool is_adjust_room = !strcmp(bpf_program__name(prog), "tc_adjust_room");
 			int expected_ret;
@@ -151,7 +156,7 @@ void test_empty_skb(void)
 			if (tests[i].adjust_room != is_adjust_room)
 				continue;
 
-			expected_ret = at_egress && !at_tc ? tests[i].lwt_egress_ret : tests[i].ret;
+			expected_ret = at_tc ? tests[i].ret : tests[i].lwt_ret;
 
 			tattr.data_in = tests[i].data_in;
 			tattr.data_size_in = tests[i].data_size_in;
-- 
2.53.0



