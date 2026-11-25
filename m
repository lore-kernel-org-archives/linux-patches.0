Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617849;
	b=o8fEIW2WhQMIV/r1l7+ZbdCGcscSS9coHUYL+v2tKVZCMzhpZ2WUKm+5RGJJb0cjq4H9
	 FwXwJ43LaBh96xKf1gu9dwgs0vej6jEwqHIo4OrYeDwWHHcnss7I1uFyhkFzToHcAYRa7
	 YRXyGMBPkEYpgdnLNf0m3+fKSHmRX8yipdbaE/stbJzN/xhVfsmkoe+XxAyBYBqMolmp+
	 LAFc5Xk2kC23C+DPKL/4iOuM2idROFLsgzKF0kOyahYXHMvxqn4Y6oo8wJMk+Bow2/dA0
	 Pq7FZfSUhPGn2X0E7WqKAdnF8WoFAP0VHhC0nBnfXA0K0kjzbtizE07IVCIJ7FIoDzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5FJA1hAZWkOQKo8esfWhLWF/DMwlRqdZaJAcH5Tb1Y=;
	b=nUurSXeMzXCEx0FBWgdUXxDh5VrVkSjDS8v8Q4KKl2SzzI+6qQOuHxQz8QOJg77CGC9o
	 /dRmdn1LJ3lPOhS5B3ShIdO/d0dni471Qumeu413M7mrH1XiFmr+yYpwRmhOqRWb3AlAM
	 Ekek+jVtiOS147LOFzQ7MVPwUQhdkUVX+eUj26V0FHtedQV2g/PFqnM6TH+qnOYbOn0Ca
	 nLYZjRnhXegn/qS78wA/FJTPp2cOcPRXko3Zj5fVySHcshCTvdMbU/Pj42TwmV+qKbHYE
	 D7YoFLEPvhwGH/lybCcc44WWSV6XeJxsmxLTvLhDS3xfI+XD8iAF8nE4yPtKO+ST3qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpLvg7jb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199D6606A31E;
	Wed, 25 Nov 2026 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpLvg7jb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A97B1F000C0;
	Wed, 25 Nov 2026 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617848;
	bh=J5FJA1hAZWkOQKo8esfWhLWF/DMwlRqdZaJAcH5Tb1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpLvg7jbkqJ+dcv34vdZAv6pk4jJ1nWWBjDuRU5foXnAtf855pazFDrW8diTjfOIY
	 Bf2kNHl+fnSixc3BFaAjBWlv1xZVqLR63TLJ8akm921cdGO9b9zwt8bv4AAJtCFQis
	 89kdQiAR2tFj/VVaxHCYVMl9Q5pOOTEHZsKM3nu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Junzhe <junzheyu1@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0094/1005] netfilter: nft_reject: prevent unbounded recursion in output hooks
Date: Wed, 25 Nov 2026 15:23:52 +0100
Message-ID: <20261125143823.945984427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit d6c18cadfc6c7a88e9e07e0a1b5ead37c0ddf866 ]

nftables payload-mangling rules can rewrite packet contents (such as TCP
flags) before they are evaluated by reject targets. This defeats the
content-based loop guards, allowing unbounded hook recursion that leads
to kernel stack exhaustion and panics.

Fix this by extracting the per-CPU xmit recursion limit previously used
by the netdev duplication/forwarding paths into a shared header, and
apply it to the inet and inet6 reject transmit functions. It disables BH
while transmitting the skb to address a possible migration to different
CPU leading to imbalanced decrementation of the recursion counters.

Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
enabled does not require this recursion guard. In that scenario, the
generated reset packet is transmitted directly at Layer 2. Because the
packet egresses from a different hook, it cannot synchronously loop. In
addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
transmit functions are protected against recursion by the
icmp_xmit_lock() and icmpv6_xmit_lock() guards.

Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/20260921061320.543-1-junzheyu1@gmail.com/
Fixes: bee11dc78fc8 ("netfilter: nft_reject: support for IPv6 and TCP reset")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice_xmit.h        |  4 +--
 include/net/netfilter/nf_dup_netdev.h | 35 ----------------------
 include/net/netfilter/nf_recursion.h  | 42 +++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c   | 12 ++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c   | 13 +++++++++
 net/netfilter/nf_dup_netdev.c         |  1 +
 net/netfilter/nft_fwd_netdev.c        |  1 +
 7 files changed, 71 insertions(+), 37 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index cc232508e695e..286ae5a6101e8 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -18,8 +18,8 @@ struct netdev_xmit {
 	u8			sched_mirred_nest;
 	struct net_device	*sched_mirred_dev[MIRRED_NEST_LIMIT];
 #endif
-#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
-	u8 nf_dup_skb_recursion;
+#if IS_ENABLED(CONFIG_NETFILTER)
+	u8 nf_xmit_skb_recursion;
 #endif
 };
 
diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index f6b05bd80c3fe..a394112646144 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -9,41 +9,6 @@
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static inline bool nf_dev_xmit_recursion(void)
-{
-	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
-			NF_RECURSION_LIMIT);
-}
-
-static inline void nf_dev_xmit_recursion_inc(void)
-{
-	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
-}
-
-static inline void nf_dev_xmit_recursion_dec(void)
-{
-	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-static inline bool nf_dev_xmit_recursion(void)
-{
-	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
-}
-
-static inline void nf_dev_xmit_recursion_inc(void)
-{
-	current->net_xmit.nf_dup_skb_recursion++;
-}
-
-static inline void nf_dev_xmit_recursion_dec(void)
-{
-	current->net_xmit.nf_dup_skb_recursion--;
-}
-#endif
-
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/include/net/netfilter/nf_recursion.h b/include/net/netfilter/nf_recursion.h
new file mode 100644
index 0000000000000..1ac65f7793f19
--- /dev/null
+++ b/include/net/netfilter/nf_recursion.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_RECURSION_H_
+#define _NF_RECURSION_H_
+
+#include <linux/netdevice.h>
+
+#define NF_RECURSION_LIMIT	2
+
+#ifndef CONFIG_PREEMPT_RT
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.nf_xmit_skb_recursion) >
+			NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.nf_xmit_skb_recursion);
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.nf_xmit_skb_recursion);
+}
+#else
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(current->net_xmit.nf_xmit_skb_recursion > NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	current->net_xmit.nf_xmit_skb_recursion++;
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	current->net_xmit.nf_xmit_skb_recursion--;
+}
+#endif
+
+#endif /* _NF_RECURSION_H_ */
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 7cb33af671e26..4082fa184af8b 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -10,6 +10,7 @@
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/netfilter/ipv4/nf_reject.h>
+#include <net/netfilter/nf_recursion.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
 
@@ -336,7 +337,18 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		dev_queue_xmit(nskb);
 	} else
 #endif
+	{
+		local_bh_disable();
+		if (nf_dev_xmit_recursion()) {
+			local_bh_enable();
+			goto free_nskb;
+		}
+
+		nf_dev_xmit_recursion_inc();
 		ip_local_out(net, nskb->sk, nskb);
+		nf_dev_xmit_recursion_dec();
+		local_bh_enable();
+	}
 
 	return;
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc88..7c94641845175 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -10,6 +10,7 @@
 #include <net/ip6_checksum.h>
 #include <net/dst_metadata.h>
 #include <net/netfilter/ipv6/nf_reject.h>
+#include <net/netfilter/nf_recursion.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
 
@@ -409,7 +410,19 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		dev_queue_xmit(nskb);
 	} else
 #endif
+	{
+		local_bh_disable();
+		if (nf_dev_xmit_recursion()) {
+			local_bh_enable();
+			kfree_skb(nskb);
+			return;
+		}
+
+		nf_dev_xmit_recursion_inc();
 		ip6_local_out(net, sk, nskb);
+		nf_dev_xmit_recursion_dec();
+		local_bh_enable();
+	}
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c6bd5c29bed66..918716629c155 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/netfilter/nf_recursion.h>
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a48c2f765bbaa..7447da931a957 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/netfilter/nf_recursion.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
 
-- 
2.53.0



